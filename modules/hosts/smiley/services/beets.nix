{user, ...}: {
    flake.modules.nixos.host_smiley = {
        pkgs,
        lib,
        ntfyPublish,
        ...
    }: let
        downloads = "/data/downloads/complete/music";
        library = "/data/media/music";
        state = "/var/lib/beets";

        yaml = pkgs.formats.yaml {};

        beetsBase = {
            library = "${state}/library.db";
            directory = library;
            threaded = "yes";
            plugins = ["musicbrainz" "fetchart" "embedart" "permissions"];
            fetchart = {
                auto = true;
                sources = ["coverart" "itunes" "amazon" "albumart"];
            };
            embedart = {
                auto = true;
                remove_art_file = true;
            };
            permissions = {
                file = "0664";
                dir = "0775";
            };
        };

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

        beetsConfigInteractive = yaml.generate "beets-config-interactive.yaml" (beetsBase
        // {
            import = {
                incremental = false;
                move = true;
                write = true;
                log = "${state}/import.log";
            };
        });

        # Shared post-import cleanup. $1 is the imported directory. After beets
        # moves matched tracks out, drop any leftover directory that no longer
        # contains audio (no *.flac / *.mp3), pruning stray cover art, .nfo,
        # metadata files and the now-empty album dir itself. Directories that
        # still hold audio are kept so nothing with music is ever deleted.
        # Depth-first (-depth) so children are pruned first; -mindepth 0 lets
        # $dir itself be removed (single-album import); never touch $root.
        cleanupScript = pkgs.writeShellApplication {
            name = "beets-cleanup";
            runtimeInputs = [pkgs.findutils pkgs.coreutils];
            text = ''
                root=${downloads}
                dir="''${1:-$root}"
                [ -d "$dir" ] || exit 0

                echo "==> Cleaning up leftover non-audio directories under $dir"
                while IFS= read -r -d "" d; do
                    [ "$d" = "$root" ] && continue
                    if [ -z "$(find "$d" -type f \( -iname '*.flac' -o -iname '*.mp3' \) -print -quit)" ]; then
                        echo "  removing (no audio): $d"
                        rm -rf -- "$d"
                    fi
                done < <(find "$dir" -mindepth 0 -depth -type d -print0)
            '';
        };

        # The automated import + cleanup pipeline. Run by the systemd service
        # (as the media user), so imported files are owned by media and
        # navidrome can read them directly. Non-interactive (slskd hook and
        # unattended use). $1 is the target directory: an album dir (slskd
        # hook) or the downloads root (full manual scan).
        importScript = pkgs.writeShellApplication {
            name = "beets-import-run";
            runtimeInputs = [pkgs.beets pkgs.coreutils pkgs.findutils pkgs.gnugrep pkgs.util-linux pkgs.gawk cleanupScript ntfyPublish];
            text = ''
                root=${downloads}
                dir="''${1:-$root}"

                # HOME/XDG are set by the unit; ensure the dirs exist so beets
                # (confuse) doesn't fail writing under them.
                mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME"

                if [ ! -d "$dir" ]; then
                    echo "beets-import: $dir does not exist" >&2
                    exit 1
                fi

                # Serialize imports across template instances: concurrent
                # album-complete events would otherwise contend on the SQLite
                # library. flock queues them (wait up to 10 min).
                exec 9>"${state}/import.lock"
                if ! flock -w 600 9; then
                    echo "beets-import: timed out waiting for import lock" >&2
                    exit 1
                fi

                # Label used in notifications: the album folder name, or
                # "downloads" for a full-tree manual import.
                if [ "$dir" = "$root" ]; then
                    label="downloads"
                else
                    label="$(basename "$dir")"
                fi

                # Track item count and import-log size before importing, so we
                # can tell afterward whether anything was actually imported and
                # whether any album went in unmatched (as-is).
                itemCount() {
                    (beet -c ${beetsConfig} stats 2>/dev/null || true) \
                        | awk -F': *' '/^Tracks/ {print $2; exit}'
                }
                logLines() {
                    [ -f "${state}/import.log" ] && wc -l <"${state}/import.log" || echo 0
                }
                before="$(itemCount)"; before="''${before:-0}"
                logBefore="$(logLines)"

                echo "==> Importing new music from $dir"
                # -q: quiet/non-interactive. Config quiet_fallback=asis imports
                # weak/no matches as-is instead of stalling on a prompt.
                if ! beet -c ${beetsConfig} import -q "$dir"; then
                    echo "beets-import: beet import failed for $dir" >&2
                    ntfy-publish smiley-music "Import failed" "x,warning" \
                        "Import failed for: $label"
                    exit 1
                fi

                beets-cleanup "$dir"

                after="$(itemCount)"; after="''${after:-0}"
                imported=$((after - before))

                # Nothing new imported (empty dir, all duplicates/skipped): stay
                # quiet, no notification.
                if [ "$imported" -le 0 ]; then
                    echo "==> Nothing imported; no notification sent"
                    echo "==> Done"
                    exit 0
                fi

                # Did any album in THIS run go in unmatched (as-is)? beets logs
                # an "asis <path>" line per unmatched album; matched imports are
                # not logged. Inspect only lines appended during this run.
                asis=0
                if [ -f "${state}/import.log" ] \
                    && tail -n "+$((logBefore + 1))" "${state}/import.log" \
                        | grep -q '^asis '; then
                    asis=1
                fi

                # Build a human-friendly label. Query the most recently added
                # album (the one just imported) for "Artist - Album"; fall back
                # to the folder name if beets has no tags. $albumartist/$album
                # are beets format placeholders, not shell variables, so keep
                # them single-quoted (ignore SC2016).
                # shellcheck disable=SC2016
                added="$( (beet -c ${beetsConfig} ls -a -f '$albumartist - $album' 'added-' 2>/dev/null || true) | head -1 || true)"
                # Trim a dangling " - " when albumartist is empty.
                added="''${added# - }"
                added="''${added% - }"
                [ -z "$added" ] && added="$label"

                # Library-wide track total for context (reuse post-import count).
                count="$after"

                if [ "$asis" -eq 1 ]; then
                    ntfy-publish smiley-music "Imported unmatched" "warning" \
                        "$added imported as-is (no match found).''${count:+ Library now at $count tracks.}"
                else
                    ntfy-publish smiley-music "Import success" "white_check_mark" \
                        "$added was imported.''${count:+ Library now at $count tracks.}"
                fi

                echo "==> Done"
            '';
        };

        # Manual/SSH entry point. `ssh -t smiley beets-import [dir]` (the karla
        # `music-import` fish function) runs an INTERACTIVE import so ad-hoc
        # runs prompt for match/skip/as-is decisions over the SSH TTY. Uses the
        # `beet` sudo wrapper (runs as media, interactive config), then prunes
        # leftover non-audio dirs. No notification and no as-is detection: you
        # see the result live in the terminal. The unattended/slskd path uses
        # the systemd service instead (see slskdImport / importScript).
        beetsImport = pkgs.writeShellApplication {
            name = "beets-import";
            runtimeInputs = [beet cleanupScript];
            text = ''
                dir="''${1:-${downloads}}"
                if [ ! -d "$dir" ]; then
                    echo "beets-import: $dir does not exist" >&2
                    exit 1
                fi
                echo "==> Interactive import from $dir"
                beet import "$dir"
                beets-cleanup "$dir"
                echo "==> Done"
            '';
        };

        # slskd DownloadDirectoryComplete hook. slskd runs as the media user, so
        # it can start the (polkit-authorized) import unit directly. It reads the
        # event JSON from $SLSKD_SCRIPT_DATA, extracts the completed album's
        # local path (validated to live under the downloads root), and starts
        # the import instance for just that album.
        slskdImport = pkgs.writeShellApplication {
            name = "slskd-import";
            runtimeInputs = [pkgs.jq pkgs.systemd];
            text = ''
                root=${downloads}
                data="''${SLSKD_SCRIPT_DATA:-}"
                if [ -z "$data" ]; then
                    echo "slskd-import: SLSKD_SCRIPT_DATA is empty" >&2
                    exit 1
                fi

                dir="$(printf '%s' "$data" | jq -r '.localDirectoryName // empty')"
                [ -z "$dir" ] && dir="$root"

                # Safety: only import paths inside the downloads root.
                case "$dir" in
                    "$root" | "$root"/*) : ;;
                    *)
                        echo "slskd-import: refusing to import $dir (outside $root)" >&2
                        exit 1
                        ;;
                esac

                echo "slskd hook: album complete -> $dir"
                exec systemctl start "beets-import@$(systemd-escape --path "$dir").service"
            '';
        };

        # Manual beets access as caligula: forwards all args to beet running as
        # the media user against the real library. e.g. `beet ls`, `beet stats`,
        # `beet modify`, `beet import <path>`. Interactive/TTY, so it uses sudo
        # rather than a systemd unit.
        beet = pkgs.writeShellApplication {
            name = "beet";
            text = ''
                exec /run/wrappers/bin/sudo -u ${user.media} -g ${user.media} \
                    --preserve-env=TERM \
                    HOME=${state} \
                    XDG_CONFIG_HOME=${state}/.config \
                    XDG_DATA_HOME=${state}/.local/share \
                    XDG_CACHE_HOME=${state}/.cache \
                    ${lib.getExe pkgs.beets} -c ${beetsConfigInteractive} "$@"
            '';
        };
    in {
        # Expose the slskd hook to download.nix (same host module).
        _module.args.slskdImport = slskdImport;

        environment.systemPackages = [beetsImport beet];

        # Templated import service, one instance per target directory. Runs as
        # the media user so imported files are media-owned; systemd handles the
        # user switch, working dir, HOME/XDG env and state-dir ownership,
        # replacing the old sudo + env-juggling wrappers. %f is the instance
        # name unescaped as a path (leading slash restored, spaces decoded);
        # %I omits the leading slash so it must not be used for the dir arg.
        systemd.services."beets-import@" = {
            description = "Import music into beets from %f";
            serviceConfig = {
                Type = "oneshot";
                User = user.media;
                Group = user.media;
                # Creates and owns /var/lib/beets (library DB + logs).
                StateDirectory = "beets";
                StateDirectoryMode = "0750";
                WorkingDirectory = state;
                # media's home is /var/empty (unwritable); point HOME/XDG at the
                # writable state dir so beets doesn't try to write under it.
                Environment = [
                    "HOME=${state}"
                    "XDG_CONFIG_HOME=${state}/.config"
                    "XDG_DATA_HOME=${state}/.local/share"
                    "XDG_CACHE_HOME=${state}/.cache"
                ];
                ExecStart = ''${lib.getExe importScript} "%f"'';
            };
        };

        # Let the media group start the import units without a password. slskd
        # (running as media) uses this to trigger the automated import service
        # from its DownloadDirectoryComplete hook.
        security.polkit = {
            enable = true;
            extraConfig = ''
                polkit.addRule(function(action, subject) {
                    if (action.id == "org.freedesktop.systemd1.manage-units" &&
                        action.lookup("unit") &&
                        action.lookup("unit").indexOf("beets-import@") == 0 &&
                        subject.isInGroup("${user.media}")) {
                        return polkit.Result.YES;
                    }
                });
            '';
        };

        # Interactive `beet` is a foreground TTY tool; run it as media via sudo
        # (no systemd unit). Only this one wrapper needs a sudo rule now.
        security.sudo-rs.extraRules = [
            {
                users = [user.primary];
                runAs = "${user.media}:${user.media}";
                commands = [
                    {
                        command = "${lib.getExe pkgs.beets} *";
                        options = ["NOPASSWD" "SETENV"];
                    }
                ];
            }
        ];
    };
}
