# Run Laravel's artisan for the project containing $PWD, inside the docker
# compose service when the project has a compose file, or with the host php.
#
#   artisan <command> [args...]   run an artisan command
#   artisan --commands [--json]   list commands (cached) as "name<TAB>description",
#                                 or as JSON objects { name, desc, has_args }
#   artisan --refresh             rebuild the command cache
#   artisan --root                print the Laravel project directory

service="${ARTISAN_DOCKER_SERVICE:-platform}"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/artisan"

die() {
    printf 'artisan: %s\n' "$1" >&2
    exit 1
}

is_laravel() {
    [ -f "$1/artisan" ] && [ -r "$1/artisan" ] && [ -f "$1/composer.json" ]
}

# The Laravel project containing $PWD or, failing that, the single one anywhere
# in the enclosing git repo (e.g. platform/ in a monorepo), or directly below
# $PWD outside git.
find_root() {
    local dir="$PWD"
    while :; do
        if is_laravel "$dir"; then
            printf '%s\n' "$dir"
            return 0
        fi
        [ "$dir" = / ] && break
        dir="$(dirname "$dir")"
    done

    local found=() git_root file
    if git_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
        # Tracked files only, so vendor/ and node_modules/ are never searched.
        while IFS= read -r -d '' file; do
            dir="$git_root/$(dirname "$file")"
            if is_laravel "$dir"; then found+=("$dir"); fi
        done < <(git -C "$git_root" ls-files -z --full-name ':(glob)**/artisan')
    else
        for dir in "$PWD"/*/; do
            dir="${dir%/}"
            if is_laravel "$dir"; then found+=("$dir"); fi
        done
    fi
    if [ "${#found[@]}" -eq 1 ]; then
        printf '%s\n' "${found[0]}"
        return 0
    fi
    if [ "${#found[@]}" -gt 1 ]; then
        printf 'artisan: multiple projects here, cd into one of: %s\n' "${found[*]##*/}" >&2
        return 2
    fi
    return 1
}

# Exec artisan with "$@". Docker compose is run from the project root so it
# picks up the right compose (and override) files; the host php keeps $PWD so
# relative path arguments still resolve.
exec_artisan() {
    local f
    for f in docker-compose.yml docker-compose.yaml; do
        if [ -r "$root/$f" ]; then
            local tty=()
            if ! [ -t 0 ] || ! [ -t 1 ]; then tty=(-T); fi
            cd "$root"
            exec docker compose exec "${tty[@]}" "$service" php artisan "$@"
        fi
    done
    exec php "$root/artisan" "$@"
}

cache_file() {
    local key="${root//\//_}"
    printf '%s/%s.json\n' "$cache_dir" "${key#_}"
}

# Print the command list as JSON, or fail if artisan returned nothing usable.
fetch_commands() {
    local json
    json="$( (exec_artisan list --format=json) </dev/null 2>/dev/null)" || true
    jq -ce '
        [ .commands[]
          | select(.name != "_complete" and .name != "completion")
          | { name,
              desc: .description,
              has_args: ((.definition.arguments // {}) | keys | any(. != "command")) } ]
        | select(length > 0)
    ' <<<"$json" 2>/dev/null
}

write_cache() {
    local file tmp
    file="$(cache_file)"
    mkdir -p "$cache_dir"
    tmp="$(mktemp "$file.XXXXXX")"
    printf '%s\n' "$1" >"$tmp"
    mv -f "$tmp" "$file"
}

# Print cached commands as JSON, fetching and caching them when the cache is
# missing or not a non-empty list of objects.
get_commands() {
    local file json
    file="$(cache_file)"
    if [ -r "$file" ] && jq -e 'type == "array" and length > 0 and (.[0] | type == "object")' "$file" >/dev/null 2>&1; then
        cat "$file"
        return 0
    fi
    json="$(fetch_commands)" || return 1
    write_cache "$json"
    printf '%s\n' "$json"
}

rc=0
root="$(find_root)" || rc=$?
if [ "$rc" -eq 1 ]; then die 'not found — are you in a Laravel project?'; fi
if [ "$rc" -ne 0 ]; then exit 1; fi

case "${1:-}" in
    --root)
        printf '%s\n' "$root"
        ;;
    --commands)
        json="$(get_commands)" || die 'no commands found'
        if [ "${2:-}" = --json ]; then
            printf '%s\n' "$json"
        else
            jq -r '.[] | "\(.name)\t\(.desc | gsub("[\t\n]"; " "))"' <<<"$json"
        fi
        ;;
    --refresh)
        json="$(fetch_commands)" || die 'no commands found, cache unchanged'
        write_cache "$json"
        printf 'artisan: cached %d commands\n' "$(jq length <<<"$json")"
        ;;
    *)
        exec_artisan "$@"
        ;;
esac
