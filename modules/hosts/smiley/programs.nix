{user, ...}: {
    flake.modules.nixos.host_smiley = {
        pkgs,
        lib,
        ...
    }: let
        downloads = "/data/downloads/complete/music";
        library = "/data/media/music";
        state = "/var/lib/beets";
        ntfyUrl = "http://localhost:2586";

        # Publish a notification to an ntfy topic. Usage:
        #   ntfy-publish <topic> <title> <tags> <message>
        # ntfy runs open (Tailscale gates access), so no auth is needed.
        # Failures to notify never fail the caller (best-effort).
        ntfyPublish = pkgs.writeShellApplication {
            name = "ntfy-publish";
            runtimeInputs = [pkgs.curl];
            text = ''
                topic="$1"; title="$2"; tags="$3"; message="$4"
                curl -fsS --max-time 10 \
                    -H "Title: $title" \
                    -H "Tags: $tags" \
                    -d "$message" \
                    "${ntfyUrl}/$topic" >/dev/null \
                    || echo "ntfy-publish: notification failed (non-fatal)" >&2
            '';
        };

        yaml = pkgs.formats.yaml {};

        # Settings shared by both the automated and interactive beets configs.
        beetsBase = {
            # Library DB and config live in the media user's state dir, created
            # and owned by media via tmpfiles below.
            library = "${state}/library.db";
            directory = library;
            threaded = "yes";
            plugins = ["musicbrainz" "fetchart" "embedart" "permissions"];
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

        # Automated config: used by the import pipeline (runner + slskd hook).
        # Never blocks on prompts; auto-accepts strong matches and imports
        # weak/no matches as-is so the pipeline never hangs.
        beetsConfig = yaml.generate "beets-config.yaml" (beetsBase
            // {
                import = {
                    incremental = true;
                    move = true;
                    write = true;
                    resume = true;
                    quiet = true;
                    quiet_fallback = "asis";
                    timid = false;
                    duplicate_action = "replace";
                    log = "${state}/import.log";
                };
            });

        # Interactive config: used by the manual `beet` wrapper. Full normal
        # beets prompting (apply/skip/as-is/duplicate handling). incremental is
        # off so manual re-imports of already-seen dirs aren't skipped.
        beetsConfigInteractive = yaml.generate "beets-config-interactive.yaml" (beetsBase
            // {
                import = {
                    incremental = false;
                    move = true;
                    write = true;
                    log = "${state}/import.log";
                };
            });

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
        # beet with the INTERACTIVE config. Used for manual commands (list,
        # modify, stats, and interactive `beet import` with prompts) so ad-hoc
        # use hits the real library and keeps media ownership.
        beetRunner = pkgs.writeShellApplication {
            name = "beet-runner";
            runtimeInputs = [pkgs.beets];
            text = ''
                ${beetsEnv}
                exec beet -c ${beetsConfigInteractive} "$@"
            '';
        };

        # The automated import + cleanup pipeline, run AS the media user so
        # imported files are owned by media and navidrome can read them directly.
        # Optional arg $1 restricts the import to a specific album directory
        # (used by the slskd DownloadDirectoryComplete hook); with no arg it
        # scans the whole downloads dir (used by the manual trigger).
        importRunner = pkgs.writeShellApplication {
            name = "music-import-runner";
            runtimeInputs = [pkgs.beets pkgs.findutils pkgs.util-linux pkgs.gawk ntfyPublish];
            text = ''
                root=${downloads}
                dir="''${1:-$root}"
                ${beetsEnv}

                # When invoked via `sudo -u media` from an SSH session, the CWD
                # is caligula's home (mode 700), which media can't access; find
                # then errors "Failed to restore initial working directory". cd
                # into a media-readable dir to avoid it.
                cd "$root" 2>/dev/null || cd /

                if [ ! -d "$dir" ]; then
                    echo "music-import: $dir does not exist" >&2
                    exit 1
                fi

                # Label used in notifications: the album folder name, or
                # "downloads" for a full-tree manual import.
                if [ "$dir" = "$root" ]; then
                    label="downloads"
                else
                    label="$(basename "$dir")"
                fi

                # Serialize imports: concurrent DownloadDirectoryComplete events
                # would otherwise contend on the SQLite library. flock queues
                # them so they run one at a time. -w 600: wait up to 10 min.
                exec 9>"${state}/import.lock"
                if ! flock -w 600 9; then
                    echo "music-import: timed out waiting for import lock" >&2
                    ntfy-publish smiley-music "Import failed" "x,warning" \
                        "Import failed for: $label (lock timeout)"
                    exit 1
                fi

                echo "==> Importing new music from $dir"
                # -q: quiet/non-interactive. Config quiet_fallback=asis imports
                # weak/no matches as-is instead of stalling on a prompt.
                # Only a real beets failure counts as failure; check explicitly
                # rather than via a blanket ERR trap (which false-fires on benign
                # non-zero pipe exits like SIGPIPE from `head` or `grep -q`).
                if ! beet -c ${beetsConfig} import -q "$dir"; then
                    echo "music-import: beet import failed for $dir" >&2
                    ntfy-publish smiley-music "Import failed" "x,warning" \
                        "Import failed for: $label"
                    exit 1
                fi

                echo "==> Cleaning up leftover non-audio directories under $dir"
                # After beets moves matched tracks out, drop any leftover
                # directory that no longer contains audio (no *.flac / *.mp3),
                # pruning stray cover art, .nfo and metadata files. Directories
                # that still hold audio are kept so nothing with music is ever
                # deleted. Depth-first (-depth) so children are pruned first.
                # Scope cleanup to $dir; never touch $root itself. `|| true`
                # keeps benign non-zero pipe exits from aborting under set -e.
                while IFS= read -r -d "" d; do
                    [ "$d" = "$root" ] && continue
                    if [ -z "$(find "$d" -type f \( -iname '*.flac' -o -iname '*.mp3' \) -print -quit)" ]; then
                        echo "  removing (no audio): $d"
                        rm -rf -- "$d"
                    fi
                done < <(find "$dir" -mindepth 1 -depth -type d -print0)

                # Build a human-friendly notification. Query the most recently
                # added album (the one just imported) for "Artist - Album"; fall
                # back to the folder name if beets has no tags (as-is import).
                # $albumartist/$album are beets format placeholders, not shell
                # variables, so keep them single-quoted (ignore SC2016).
                # `|| true` guards against SIGPIPE from `head` under pipefail.
                # shellcheck disable=SC2016
                added="$( (beet -c ${beetsConfig} ls -a -f '$albumartist - $album' 'added-' 2>/dev/null || true) | head -1 || true)"
                # Trim a dangling " - " when albumartist is empty.
                added="''${added# - }"
                added="''${added% - }"
                [ -z "$added" ] && added="$label"

                count="$( (beet -c ${beetsConfig} stats 2>/dev/null || true) | awk -F': *' '/^Tracks/ {print $2; exit}' || true)"

                ntfy-publish smiley-music "Import success" "white_check_mark" \
                    "$added was imported.''${count:+ Library now at $count tracks.}"

                echo "==> Done"
            '';
        };

        # slskd DownloadDirectoryComplete hook. slskd already runs as the media
        # user, so this is invoked directly (no sudo). It reads the event JSON
        # from $SLSKD_SCRIPT_DATA, extracts the completed album's local path, and
        # imports just that album. The path is validated to live under the
        # downloads dir before acting.
        slskdImport = pkgs.writeShellApplication {
            name = "slskd-import";
            runtimeInputs = [pkgs.jq importRunner];
            text = ''
                root=${downloads}
                data="''${SLSKD_SCRIPT_DATA:-}"
                if [ -z "$data" ]; then
                    echo "slskd-import: SLSKD_SCRIPT_DATA is empty" >&2
                    exit 1
                fi

                dir="$(printf '%s' "$data" | jq -r '.localDirectoryName // empty')"
                if [ -z "$dir" ]; then
                    echo "slskd-import: no localDirectoryName in event; importing whole downloads dir" >&2
                    dir="$root"
                fi

                # Safety: only import paths inside the downloads root.
                case "$dir" in
                    "$root" | "$root"/*) : ;;
                    *)
                        echo "slskd-import: refusing to import $dir (outside $root)" >&2
                        exit 1
                        ;;
                esac

                echo "slskd hook: album complete -> $dir"
                exec music-import-runner "$dir"
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
        # Expose the slskd hook script to download.nix (same host module) so the
        # slskd service can reference it in integrations.scripts.
        _module.args.slskdImport = slskdImport;

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
