{user, ...}: {
    flake.modules.nixos.host_smiley = {
        pkgs,
        lib,
        ...
    }: let
        downloads = "/data/downloads/complete/music";
        library = "/data/media/music";
        state = "/var/lib/beets";

        yaml = pkgs.formats.yaml {};
        beetsConfig = yaml.generate "beets-config.yaml" {
            # Library DB and config live in the media user's state dir, created
            # and owned by media via tmpfiles below.
            library = "${state}/library.db";
            directory = library;
            threaded = "yes";
            plugins = ["musicbrainz" "fetchart" "embedart" "permissions"];
            import = {
                incremental = true;
                move = true;
                write = true;
                # Unattended import: never block on prompts. Auto-accept strong
                # matches; import weak/no matches as-is (keep tags) rather than
                # stalling so the pipeline never hangs.
                resume = false;
                quiet = true;
                quiet_fallback = "asis";
                timid = false;
                # Never prompt on duplicates; keep both rather than block.
                duplicate_action = "keep";
                log = "${state}/import.log";
            };
            # Download art from remote sources and embed it into each track.
            # No standalone cover.jpg is kept (embedart removes it).
            fetchart = {
                auto = true;
                sources = ["coverart" "itunes" "amazon" "albumart"];
            };
            embedart = {
                auto = true;
                remove_art_file = true;
            };
            # Ensure imported files/dirs are group-writable so other members of
            # the media group (e.g. caligula) can manage them.
            permissions = {
                file = "0664";
                dir = "0775";
            };
        };

        # The media user's home is /var/empty (unwritable). Point HOME and XDG
        # dirs at the writable state dir so confuse/beets don't try to create
        # ~/.config under /var/empty. Sourced by every media-side beets runner.
        beetsEnv = ''
            export HOME=${state}
            export XDG_CONFIG_HOME=${state}/.config
            export XDG_DATA_HOME=${state}/.local/share
            export XDG_CACHE_HOME=${state}/.cache
            mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME"
        '';

        # Generic beets entry point run AS the media user: forwards all args to
        # beet with the shared config. Used for manual commands (list, modify,
        # stats, manual import, etc.) so ad-hoc use hits the real library and
        # keeps media ownership.
        beetRunner = pkgs.writeShellApplication {
            name = "beet-runner";
            runtimeInputs = [pkgs.beets];
            text = ''
                ${beetsEnv}
                exec beet -c ${beetsConfig} "$@"
            '';
        };

        # The automated import + cleanup pipeline, run AS the media user so
        # imported files are owned by media and navidrome can read them directly.
        importRunner = pkgs.writeShellApplication {
            name = "music-import-runner";
            runtimeInputs = [pkgs.beets pkgs.findutils];
            text = ''
                dir=${downloads}
                ${beetsEnv}

                if [ ! -d "$dir" ]; then
                    echo "music-import: $dir does not exist" >&2
                    exit 1
                fi

                echo "==> Importing new music from $dir"
                # -q: quiet/non-interactive. Config quiet_fallback=asis imports
                # weak/no matches as-is instead of stalling on a prompt.
                beet -c ${beetsConfig} import -q "$dir"

                echo "==> Cleaning up leftover non-audio directories under $dir"
                # After beets moves matched tracks out, drop any leftover album
                # directory that no longer contains audio (no *.flac / *.mp3),
                # pruning stray cover art, .nfo and metadata files. Directories
                # that still hold audio are kept so nothing with music is ever
                # deleted. Depth-first (-depth) so children are pruned first.
                while IFS= read -r -d "" d; do
                    if ! find "$d" -type f \
                        \( -iname '*.flac' -o -iname '*.mp3' \) \
                        -print -quit | grep -q .; then
                        echo "  removing (no audio): $d"
                        rm -rf -- "$d"
                    fi
                done < <(find "$dir" -mindepth 1 -depth -type d -print0)

                echo "==> Done"
            '';
        };

        # Use the setuid sudo wrapper on the system PATH, NOT a package in
        # runtimeInputs: the raw sudo-rs binary isn't setuid and fails with
        # "sudo must be owned by uid 0 and have the setuid bit set".
        sudoAsMedia = "/run/wrappers/bin/sudo -u ${user.media} -g ${user.media}";

        # SSH entry point for the automated pipeline. `ssh smiley beets-import`
        # (or the music-import fish function) triggers it from karla or mobile.
        music-import = pkgs.writeShellApplication {
            name = "beets-import";
            text = ''
                exec ${sudoAsMedia} ${lib.getExe importRunner}
            '';
        };

        # Manual beets access as caligula: forwards all args to beet running as
        # the media user against the real library. e.g. `beet ls`, `beet stats`,
        # `beet modify`, `beet import <path>`.
        beet = pkgs.writeShellApplication {
            name = "beet";
            text = ''
                exec ${sudoAsMedia} ${lib.getExe beetRunner} "$@"
            '';
        };
    in {
        programs.ssh.startAgent = true;
        # Note: our `beet` wrapper (runs as media) must win over pkgs.beets on
        # PATH. It does, as environment.systemPackages later entries take
        # precedence, but keep pkgs.beets out to avoid ambiguity.
        environment.systemPackages = [music-import beet];

        # media-owned state dir for the beets library DB and logs.
        systemd.tmpfiles.rules = [
            "d ${state} 0750 ${user.media} ${user.media} -"
        ];

        # Allow the primary user to run the beets runners as the media user
        # without a password, so both the pipeline and manual `beet` are
        # unattended.
        security.sudo-rs.extraRules = [
            {
                users = [user.primary];
                runAs = "${user.media}:${user.media}";
                commands = [
                    {
                        command = lib.getExe importRunner;
                        options = ["NOPASSWD" "SETENV"];
                    }
                    {
                        command = "${lib.getExe beetRunner} *";
                        options = ["NOPASSWD" "SETENV"];
                    }
                    {
                        command = lib.getExe beetRunner;
                        options = ["NOPASSWD" "SETENV"];
                    }
                ];
            }
        ];
    };
}
