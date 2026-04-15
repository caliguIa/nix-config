{
    flake.modules.homeManager.core = {
        pkgs,
        config,
        ...
    }: {
        xdg.configFile."filen-cli/syncPairs.json".text = ''
            [
            	{
            		"local": "${config.xdg.dataHome}/notes",
            		"remote": "/notes",
                    "alias": "notes",
            		"syncMode": "twoWay",
            		"disableLocalTrash": true,
            		"excludeDotFiles": true
            	}
            ]
        '';
        systemd.user.services.note-sync = {
            Unit = {
                Description = "filen notes sync";
                After = ["network-online.target"];
                Wants = ["network-online.target"];
            };
            Service = {
                Type = "oneshot";
                ExecStart = "${pkgs.filen-cli}/bin/filen sync notes";
                StandardOutput = "append:%S/note-sync.log";
                StandardError = "append:%S/note-sync.log";
            };
        };
        systemd.user.timers.note-sync = {
            Unit.Description = "filen notes sync every 5 minutes";
            Timer = {
                OnBootSec = "1min";
                OnUnitActiveSec = "5min";
                Persistent = true;
            };
            Install.WantedBy = ["timers.target"];
        };
        home.packages = let
            note = pkgs.writeShellApplication {
                name = "note";

                runtimeInputs = with pkgs; [
                    fzf
                    findutils
                    gawk
                    gnused
                    coreutils
                ];

                text = ''
                    # ── Config ──────────────────────────────────────────────────────────────
                    NOTES_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/notes"
                    FILEN_REMOTE="notes"
                    LOG_FILE="''${XDG_STATE_HOME:-$HOME/.local/state}/note-sync.log"

                    # ── Helpers ─────────────────────────────────────────────────────────────
                    die()  { echo "note: error: $*" >&2; exit 1; }
                    info() { echo "note: $*"; }

                    ensure_dir() {
                        mkdir -p "$NOTES_DIR"
                    }

                    slugify() {
                        echo "$*" \
                            | tr '[:upper:]' '[:lower:]' \
                            | sed 's/[^a-z0-9 ]//g' \
                            | tr ' ' '-' \
                            | sed 's/-\+/-/g; s/^-//; s/-$//'
                    }

                    log_error() {
                        mkdir -p "$(dirname "$LOG_FILE")"
                        printf '[%s] ERROR: %s\n' "$(date '+%Y-%m-%dT%H:%M:%S')" "$*" >> "$LOG_FILE"
                    }

                    filen_sync() {
                        local out
                        if ! out=$(filen sync "$FILEN_REMOTE" 2>&1); then
                            log_error "filen sync failed: $out"
                            echo "note: warning: filen sync failed — see $LOG_FILE" >&2
                        fi
                    }

                    bg_sync() {
                        filen_sync &
                        disown
                        info "syncing in background — log: $LOG_FILE"
                    }

                    # ── Commands ─────────────────────────────────────────────────────────────
                    cmd_new() {
                        ensure_dir

                        local title_input slug filepath
                        printf "note title: "
                        read -r title_input

                        [[ -z "$title_input" ]] && die "title cannot be empty"

                        slug="$(slugify "$title_input")"
                        [[ -z "$slug" ]] && die "title produced an empty slug (use alphanumeric characters)"

                        filepath="$NOTES_DIR/$(date +%Y-%m-%d)-''${slug}.md"

                        [[ -f "$filepath" ]] && die "note already exists: $filepath"

                        printf "# %s\n\n" "$title_input" > "$filepath"

                        info "opening $filepath"
                        "''${EDITOR:-nvim}" "$filepath"

                        local lines
                        lines="$(wc -l < "$filepath")"
                        if [[ "$lines" -le 2 ]]; then
                            info "note appears empty — skipping sync (file kept locally)"
                        else
                            bg_sync
                        fi
                    }

                    cmd_list() {
                        ensure_dir

                        local -a files
                        mapfile -t files < <(
                            find "$NOTES_DIR" -maxdepth 1 -name "*.md" -printf "%T@ %p\n" 2>/dev/null \
                                | sort -rn \
                                | awk '{print $2}'
                        )

                        if [[ ''${#files[@]} -eq 0 ]]; then
                            info "no notes found in $NOTES_DIR"
                            exit 0
                        fi

                        local now
                        now=$(date +%s)

                        local selected
                        selected=$(
                            for f in "''${files[@]}"; do
                                local name mtime age mod_ago
                                name="$(basename "$f" .md)"
                                mtime="$(stat -c %Y "$f")"
                                age=$(( now - mtime ))
                                if   (( age < 60 ));    then mod_ago="just now"
                                elif (( age < 3600 ));  then mod_ago="$(( age / 60 ))m ago"
                                elif (( age < 86400 )); then mod_ago="$(( age / 3600 ))h ago"
                                else                        mod_ago="$(( age / 86400 ))d ago"
                                fi
                                printf "%-12s  %s\n" "$mod_ago" "$name"
                            done \
                            | fzf --ansi \
                                  --prompt="note > " \
                                  --height=40% \
                                  --reverse \
                                  --no-info \
                                  --bind="ctrl-d:delete-char/eof"
                        ) || exit 0

                        [[ -z "$selected" ]] && exit 0

                        local chosen_slug chosen_file
                        chosen_slug="$(echo "$selected" | awk '{print $NF}')"
                        chosen_file="$(find "$NOTES_DIR" -maxdepth 1 -name "*''${chosen_slug}.md" | head -1)"

                        [[ -z "$chosen_file" || ! -f "$chosen_file" ]] && die "could not resolve file for: $chosen_slug"

                        "''${EDITOR:-nvim}" "$chosen_file"
                        bg_sync
                    }

                    cmd_sync() {
                        ensure_dir
                        info "syncing..."
                        filen_sync
                        info "done"
                    }

                    cmd_help() {
                        cat <<HELP
                    usage: note [command]

                    commands:
                      (none)   list notes (default)
                      new      create a new note (prompts for title, opens \$EDITOR, syncs in background on exit)
                      list     list local notes by recency via fzf, sync in background after editing
                      sync     blocking two-way sync with filen (run after switching devices)
                      help     show this help

                    config (env overrides):
                      NOTES_DIR    local notes directory  [$NOTES_DIR]
                      EDITOR       editor                 [''${EDITOR:-nvim}]
                      LOG_FILE     error log              [$LOG_FILE]
                      filen sync pair alias:              $FILEN_REMOTE
                    HELP
                    }

                    # ── Dispatch ─────────────────────────────────────────────────────────────
                    case "''${1:-list}" in
                        new)  cmd_new  ;;
                        list) cmd_list ;;
                        sync) cmd_sync ;;
                        help|--help|-h) cmd_help ;;
                        *) die "unknown command ''${1}. Run 'note help' for usage." ;;
                    esac
                '';
            };
        in [note];
    };
}
