{
    flake.modules.nixos.core = {pkgs, ...}: {
        environment.systemPackages = [
            (pkgs.writeShellScriptBin "note" ''
                # note — a minimal filen-backed markdown note system
                # Commands: new, list, sync, help

                set -euo pipefail

                # ── Config ────────────────────────────────────────────────────────────────────
                NOTES_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/notes"
                FILEN_REMOTE="notes"           # filen remote path — adjust to match your setup
                EDITOR="''${EDITOR:-nvim}"

                # ── Helpers ───────────────────────────────────────────────────────────────────
                die()  { echo "note: error: $*" >&2; exit 1; }
                info() { echo "note: $*"; }

                require() {
                    for cmd in "$@"; do
                        command -v "$cmd" &>/dev/null || die "'$cmd' not found in PATH"
                    done
                }

                ensure_dir() {
                    mkdir -p "$NOTES_DIR"
                }

                slugify() {
                    # lowercase, spaces/special chars → hyphens, collapse runs, strip leading/trailing
                    echo "$*" \
                        | tr '[:upper:]' '[:lower:]' \
                        | sed 's/[^a-z0-9 ]//g' \
                        | tr ' ' '-' \
                        | sed 's/-\+/-/g; s/^-//; s/-$//'
                }

                filen_sync() {
                    local file="$1"
                    local filename
                    filename="$(basename "$file")"

                    info "syncing $filename to filen..."
                    if filen upload "$file" "$FILEN_REMOTE/$filename" 2>/dev/null; then
                        info "synced ✓"
                    else
                        echo "note: warning: filen sync failed (note saved locally)" >&2
                    fi
                }

                # ── Commands ──────────────────────────────────────────────────────────────────
                cmd_new() {
                    require filen

                    ensure_dir

                    # prompt for title slug
                    local title_input slug filepath
                    printf "note title: "
                    read -r title_input

                    [[ -z "$title_input" ]] && die "title cannot be empty"

                    slug="$(slugify "$title_input")"
                    [[ -z "$slug" ]] && die "title produced an empty slug (use alphanumeric characters)"

                    local date_prefix
                    date_prefix="$(date +%Y-%m-%d)"
                    filepath="$NOTES_DIR/''${date_prefix}-''${slug}.md"

                    # guard against clobbering
                    if [[ -f "$filepath" ]]; then
                        die "note already exists: $filepath"
                    fi

                    # write minimal frontmatter header
                    {
                        printf "# %s\n" "$title_input"
                        printf "\n"
                    } > "$filepath"

                    info "opening $filepath"
                    $EDITOR "$filepath"

                    # only sync if the file has content beyond the header stub
                    local lines
                    lines="$(wc -l < "$filepath")"
                    if [[ "$lines" -le 2 ]]; then
                        info "note appears empty — skipping sync (file kept locally)"
                    else
                        filen_sync "$filepath"
                    fi
                }

                cmd_list() {
                    ensure_dir

                    # collect .md files, sort by modification time (newest first)
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

                    if command -v fzf &>/dev/null; then
                        # build display lines: relative-time-padded filename → full path for opening
                        local selected
                        selected=$(
                            for f in "''${files[@]}"; do
                                local name mod_ago
                                name="$(basename "$f" .md)"
                                # human-readable age using stat mtime
                                mod_ago="$(stat -c %Y "$f" | xargs -I{} bash -c '
                                    now=$(date +%s); age=$((now - {}))
                                    if   (( age < 60 ));     then echo "just now"
                                    elif (( age < 3600 ));   then echo "$((age/60))m ago"
                                    elif (( age < 86400 ));  then echo "$((age/3600))h ago"
                                    elif (( age < 604800 )); then echo "$((age/86400))d ago"
                                    else                          echo "$((age/86400))d ago"
                                    fi
                                ')"
                                printf "%-12s  %s\n" "$mod_ago" "$name"
                            done \
                            | fzf --ansi \
                                  --prompt="note > " \
                                  --height=40% \
                                  --reverse \
                                  --no-info \
                                  --bind="ctrl-d:delete-char/eof"
                        ) || exit 0   # fzf exits 130 on Esc/ctrl-c — treat as graceful exit

                        [[ -z "$selected" ]] && exit 0

                        # extract the slug back to a filename
                        local chosen_slug chosen_file
                        chosen_slug="$(echo "$selected" | awk '{print $NF}')"
                        # find the matching file (there may be a date prefix)
                        chosen_file="$(find "$NOTES_DIR" -maxdepth 1 -name "*''${chosen_slug}.md" | head -1)"

                        [[ -z "$chosen_file" || ! -f "$chosen_file" ]] && die "could not resolve file for: $chosen_slug"

                        $EDITOR "$chosen_file"
                        filen_sync "$chosen_file"
                    else
                        # no fzf — just print the list
                        info "fzf not found, listing notes:"
                        for f in "''${files[@]}"; do
                            basename "$f" .md
                        done
                    fi
                }

                cmd_sync() {
                    require filen
                    ensure_dir

                    info "syncing all notes to filen/$FILEN_REMOTE..."
                    local count=0
                    for f in "$NOTES_DIR"/*.md; do
                        [[ -f "$f" ]] || continue
                        filen upload "$f" "$FILEN_REMOTE/$(basename "$f")" 2>/dev/null && (( count++ )) || \
                            echo "note: warning: failed to sync $(basename "$f")" >&2
                    done
                    info "synced $count note(s) ✓"
                }

                cmd_help() {
                    cat <<EOF
                usage: note <command> [args]

                commands:
                  new      create a new note (prompts for title, opens \$EDITOR, syncs on exit)
                  list     list notes by recency, open selected in \$EDITOR via fzf
                  sync     push all local notes to filen
                  help     show this help

                config (env overrides):
                  NOTES_DIR   local notes directory  [''${NOTES_DIR}]
                  EDITOR      editor to open notes   [''${EDITOR}]
                  filen remote path hardcoded to:    ''${FILEN_REMOTE}/
                EOF
                }

                # ── Dispatch ──────────────────────────────────────────────────────────────────
                case "''${1:-help}" in
                    new)  cmd_new  ;;
                    list) cmd_list ;;
                    sync) cmd_sync ;;
                    help|--help|-h) cmd_help ;;
                    *) die "unknown command ''${1}. Run 'note help' for usage." ;;
                esac
            '')
        ];
    };
}
