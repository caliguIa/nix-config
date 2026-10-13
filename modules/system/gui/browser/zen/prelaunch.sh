# Runs before every Zen launch and merges the declared containers, spaces and
# pins into the profile. Never fatal: the launcher execs Zen whatever happens.
# Expects ZEN_SESSION_JQ, ZEN_CONTAINERS_JQ, ZEN_TOOLBAR_JQ, ZEN_DECLARED_SESSION,
# ZEN_DECLARED_CONTAINERS and ZEN_DECLARED_TOOLBAR from the nix wrapper.

log() {
    echo "zen-declarative: $*" >&2
}

# Print "<IsRelative> <Path>" of the Default=1 profile, else the first one.
default_profile() {
    awk '
        function flush() {
            if (!inprofile || path == "") return
            if (first == "") first = rel " " path
            if (isdefault && chosen == "") chosen = rel " " path
        }
        { sub(/\r$/, "") }
        /^\[/ { flush(); inprofile = ($0 ~ /^\[Profile/); path = ""; rel = "1"; isdefault = 0; next }
        {
            val = substr($0, index($0, "=") + 1)
            if ($0 ~ /^Path=/) path = val
            else if ($0 ~ /^IsRelative=/) rel = val
            else if ($0 ~ /^Default=1$/) isdefault = 1
        }
        END { flush(); print (chosen != "" ? chosen : first) }
    ' "$1"
}

# Succeeds when a Zen instance holds the profile. Gecko takes an fcntl lock
# on .parentlock, which a flock(1) probe cannot see, and taking our own lock
# could make Zen fail to start, so look for an open handle instead. The `lock`
# symlink (ip:+pid) is a second opinion for when lsof is blind.
profile_in_use() {
    local dir=$1 target pid
    # lsof can hang on stale FUSE mounts, so a timeout counts as in use.
    local rc=0
    timeout 2 lsof -w -- "$dir/.parentlock" >/dev/null 2>&1 || rc=$?
    ((rc == 0 || rc == 124)) && return 0
    target=$(readlink "$dir/lock" 2>/dev/null) || return 1
    pid=${target##*+}
    [[ $pid =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null
}

# merge_json <jq file> <declared json> <file> <compressed: 1|0>
# Applies the jq program, writing only when the result differs.
merge_json() {
    local jqfile=$1 declared=$2 file=$3 compressed=$4
    local dir tmp_in tmp_out tmp_new backup
    dir=$(dirname "$file")
    backup="$file.declarative-backup"
    tmp_in=$(mktemp) tmp_out=$(mktemp)
    tmp_new="$file.declarative-tmp"
    # shellcheck disable=SC2064
    trap "rm -f '$tmp_in' '$tmp_out' '$tmp_new'" RETURN

    if ((compressed)); then
        mozlz4a -d "$file" "$tmp_in" || { log "cannot decompress $file"; return 1; }
    else
        cat "$file" >"$tmp_in"
    fi
    jq --slurpfile declared "$declared" -f "$jqfile" "$tmp_in" >"$tmp_out" || { log "jq failed on $file"; return 1; }
    jq -e 'type == "object"' "$tmp_out" >/dev/null || { log "merge of $file is not a JSON object"; return 1; }

    # Key order is irrelevant to Gecko, so compare sorted.
    if [[ $(jq -cS . "$tmp_in") == "$(jq -cS . "$tmp_out")" ]]; then
        return 0
    fi

    cp -p "$file" "$backup" || { log "cannot back up $file"; return 1; }
    if ((compressed)); then
        mozlz4a "$tmp_out" "$tmp_new" || { log "cannot compress $file"; return 1; }
        mozlz4a -d "$tmp_new" - >/dev/null 2>&1 || { log "compressed $file does not round-trip"; return 1; }
    else
        cp "$tmp_out" "$tmp_new" || return 1
    fi
    [[ -s $tmp_new ]] || { log "refusing to write empty $file"; return 1; }
    mv -f "$tmp_new" "$file" || { cp -p "$backup" "$file"; log "write failed, restored $file"; return 1; }
    log "updated ${file##*/} in ${dir##*/}"
}

# merge_toolbar <prefs.js>
# Rewrites the one browser.uiCustomization.state line and nothing else. The
# value is a JS string holding JSON, so it is parsed as JSON twice and written
# back the same way. Leaves prefs.js alone if the pref is absent or anything
# fails.
merge_toolbar() {
    local prefix='user_pref("browser.uiCustomization.state", ' file=$1 lineno raw literal state new newline tmp backup=$1.declarative-backup
    lineno=$(grep -n '^user_pref("browser.uiCustomization.state", ' "$file" | cut -d: -f1)
    [[ -n $lineno ]] || return 0
    [[ $lineno =~ ^[0-9]+$ ]] || { log "several toolbar prefs in $file, leaving it alone"; return 1; }

    raw=$(sed -n "${lineno}p" "$file")
    literal=${raw#"$prefix"}
    literal=${literal%');'}
    state=$(printf '%s' "$literal" | jq -Rce 'fromjson | fromjson') || { log "cannot parse the toolbar pref"; return 1; }
    new=$(printf '%s' "$state" | jq -c --slurpfile declared "$ZEN_DECLARED_TOOLBAR" -f "$ZEN_TOOLBAR_JQ") || { log "toolbar jq failed"; return 1; }
    [[ -n $new && $new != "$state" ]] || return 0

    newline=$(jq -nr --arg s "$new" '"user_pref(\"browser.uiCustomization.state\", \($s | tojson));"') || return 1
    tmp="$file.declarative-tmp"
    # shellcheck disable=SC2064
    trap "rm -f '$tmp'" RETURN
    cp -p "$file" "$backup" || { log "cannot back up $file"; return 1; }
    cp -p "$file" "$tmp" || return 1
    NEWLINE=$newline awk -v n="$lineno" 'NR == n { print ENVIRON["NEWLINE"]; next } { print }' "$file" >"$tmp" || return 1

    # Same line count, and the new line must parse back to what was intended.
    [[ $(wc -l <"$tmp") == "$(wc -l <"$file")" ]] || { log "toolbar edit changed the line count"; return 1; }
    raw=$(sed -n "${lineno}p" "$tmp")
    raw=${raw#"$prefix"}
    raw=${raw%');'}
    [[ $(printf '%s' "$raw" | jq -Rce 'fromjson | fromjson') == "$new" ]] || { log "toolbar edit does not round-trip"; return 1; }
    mv -f "$tmp" "$file" || { cp -p "$backup" "$file"; log "write failed, restored $file"; return 1; }
    log "updated toolbar in ${file##*/}"
}

main() {
    local arg flag
    # Only the default profile is managed, so leave explicit profile choices alone.
    for arg in "$@"; do
        flag=${arg,,}
        flag=${flag##-}
        flag=${flag##-}
        case $flag in
            p | p=* | profile | profile=* | profilemanager)
                log "profile chosen on the command line, skipping"
                return 0
                ;;
        esac
    done
    local base conf="${XDG_CONFIG_HOME:-$HOME/.config}/zen" legacy="$HOME/.zen" line rel path profile
    for base in "$conf" "$legacy"; do
        [[ -f $base/profiles.ini ]] && break
        base=
    done
    [[ -n $base ]] || { log "no profiles.ini, skipping"; return 0; }

    line=$(default_profile "$base/profiles.ini")
    rel=${line%% *}
    path=${line#* }
    [[ -n $path && $path != "$line" ]] || { log "no profile in $base/profiles.ini, skipping"; return 0; }
    if [[ $rel == 1 ]]; then profile="$base/$path"; else profile=$path; fi
    [[ -d $profile ]] || { log "profile $profile missing, skipping"; return 0; }

    if profile_in_use "$profile"; then
        log "profile in use, skipping"
        return 0
    fi

    if [[ -f $profile/containers.json ]]; then
        merge_json "$ZEN_CONTAINERS_JQ" "$ZEN_DECLARED_CONTAINERS" "$profile/containers.json" 0 || true
    fi
    if [[ -f $profile/prefs.js ]]; then
        merge_toolbar "$profile/prefs.js" || true
    fi
    if [[ -f $profile/zen-sessions.jsonlz4 ]]; then
        merge_json "$ZEN_SESSION_JQ" "$ZEN_DECLARED_SESSION" "$profile/zen-sessions.jsonlz4" 1 || true
    fi
}

main "$@" || true
