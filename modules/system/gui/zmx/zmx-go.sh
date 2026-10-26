# zmx-go: one terminal window per zmx session, driven from sway.
#
#   zmx-go open [name] [dir]  focus the window for session <name>, or open one
#                             (creating the session in <dir>); no name picks a
#                             fresh one from <dir>'s basename
#   zmx-go here               attach this terminal to a fresh session for $PWD
#   zmx-go sessions           fzf over running sessions
#   zmx-go projects           fzf over git repos in ~ and ~/dev

# fzf runs binds and previews through $SHELL, which is fish
export FZF_DEFAULT_SHELL="$BASH"

sanitize() {
    local s
    s=$(printf '%s' "$1" | tr -c 'A-Za-z0-9_-' '-')
    s=${s#-}
    printf '%s' "${s:-session}"
}

session_exists() {
    # not a pipe: grep -q exiting early would SIGPIPE zmx and trip pipefail
    grep -qxF -- "$1" <<<"$(zmx list --short 2>/dev/null)"
}

fresh_name() {
    local dir=${1:-$HOME} base name n=2
    if [ "$dir" = "$HOME" ]; then base=home; else base=$(basename "$dir"); fi
    base=$(sanitize "$base")
    name=$base
    while session_exists "$name"; do
        name="$base-$n"
        n=$((n + 1))
    done
    printf '%s\n' "$name"
}

# sway criteria values are regexes inside double quotes
criteria_re() {
    printf '%s' "$1" | sed 's/[][\\.^$*+?(){}|"]/\\&/g'
}

open_session() {
    local name=${1:-} dir=${2:-$HOME} re
    [ -n "$name" ] || name=$(fresh_name "$dir")
    re=$(criteria_re "$name")
    # windows opened here carry a fixed "zmx: <name>" title; ones attached in place
    # by `zmx-go here` carry a "zmx:<name>" mark
    if swaymsg -q "[app_id=\"com.mitchellh.ghostty\" title=\"^zmx: $re\$\"] focus" 2>/dev/null ||
        swaymsg -q "[con_mark=\"^zmx:$re\$\"] focus" 2>/dev/null; then
        return
    fi
    stack_onto_terminal
    # spawn through sway so the window outlives the picker that asked for it
    swaymsg -q exec -- "$(printf '%q ' \
        "$(command -v ghostty)" --title="zmx: $name" --working-directory="$dir" \
        -e "$(command -v zmx)" attach "$name")"
}

# Focus the most recently used terminal on this workspace, wrapped in a tabbed
# container, so the window about to open lands as another tab beside it rather
# than splitting the screen.
stack_onto_terminal() {
    local id layout
    read -r id layout < <(swaymsg -t get_tree | jq -r '
        def kids: .layout as $l | .focus as $f
            | (.nodes // []) | sort_by(.id as $i | ($f | index($i)) // 1e9) | .[]
            | ({id, layout: $l, app_id}, kids);
        first(.. | select(.type? == "workspace" and any(..; .focused? == true))
            | kids | select(.app_id == "com.mitchellh.ghostty"))
        | "\(.id) \(.layout)"') || return 0
    [ -n "$id" ] || return 0
    case $layout in
        tabbed | stacked) swaymsg -q "[con_id=$id] focus" ;;
        *) swaymsg -q "[con_id=$id] focus; split vertical; layout tabbed" ;;
    esac || true
}

# attach this terminal to a fresh session, marking its sway window so the
# pickers can focus it later
attach_here() {
    local name
    name=$(fresh_name "$PWD")
    if [ -n "${SWAYSOCK:-}" ]; then
        swaymsg -q "[con_id=__focused__ app_id=\"com.mitchellh.ghostty\"] mark --add \"zmx:$name\"" 2>/dev/null || true
    fi
    exec zmx attach "$name"
}

list_sessions() {
    { zmx list 2>/dev/null || true; } | awk -F'\t' '{
        name = ""; clients = 0; cwd = ""
        for (i = 1; i <= NF; i++) {
            f = $i
            sub(/^[^a-z]*/, "", f)
            split(f, kv, "=")
            if (kv[1] == "name") name = substr(f, 6)
            else if (kv[1] == "clients") clients = kv[2]
            else if (kv[1] == "cwd") { cwd = substr(f, 5); sub(/^file:\/\/[^\/]*/, "", cwd) }
        }
        if (name == "") next
        sub("^" ENVIRON["HOME"], "~", cwd)
        printf "%s\t%s\t%s\n", name, (clients > 0 ? "●" : " "), cwd
    }'
}

pick_sessions() {
    local out query sel
    # shellcheck disable=SC2016 # the preview's $vars expand inside fzf
    out=$(list_sessions | fzf \
        --delimiter='\t' --print-query --reverse --no-sort \
        --prompt='session › ' \
        --header='enter open · ctrl-x kill · unmatched name + enter creates it · ● attached' \
        --bind="ctrl-x:execute-silent(zmx kill {1})+reload($0 list-sessions)" \
        --preview='zmx history {1} 2>/dev/null | tail -n "$FZF_PREVIEW_LINES"' \
        --preview-window='right,60%,follow') || [ $? -eq 1 ] || return 0
    query=$(sed -n 1p <<<"$out")
    sel=$(sed -n 2p <<<"$out")
    if [ -n "$sel" ]; then
        open_session "${sel%%$'\t'*}"
    elif [ -n "$query" ]; then
        open_session "$(sanitize "$query")"
    fi
}

list_projects() {
    local running
    running=$(zmx list --short 2>/dev/null || true)
    {
        find "$HOME" -mindepth 2 -maxdepth 2 -name .git -printf '%h\n' 2>/dev/null || true
        find "$HOME/dev" -mindepth 2 -maxdepth 3 -name .git -printf '%h\n' 2>/dev/null || true
    } | sort -u | while read -r dir; do
        name=$(sanitize "$(basename "$dir")")
        mark=" "
        grep -qxF -- "$name" <<<"$running" && mark="●"
        printf '%s\t%s\t%s\t%s\n' "$name" "$mark" "${dir/#$HOME/\~}" "$dir"
    done
}

pick_projects() {
    local sel name dir
    sel=$(list_projects | fzf \
        --delimiter='\t' --with-nth=1,2,3 --reverse \
        --prompt='project › ' \
        --header='enter open or focus · ● session running' \
        --preview='git -C {4} -c color.status=always status -sb; echo; git -C {4} log --oneline --color=always -20' \
        --preview-window='right,55%') || return 0
    IFS=$'\t' read -r name _ _ dir <<<"$sel"
    open_session "$name" "$dir"
}

case ${1:-} in
    open) shift; open_session "$@" ;;
    here) attach_here ;;
    sessions) pick_sessions ;;
    projects) pick_projects ;;
    list-sessions) list_sessions ;;
    *)
        echo "usage: zmx-go {open [name] [dir] | here | sessions | projects}" >&2
        exit 2
        ;;
esac
