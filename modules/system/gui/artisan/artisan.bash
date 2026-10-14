_artisan() {
    local cur cword
    if declare -F _get_comp_words_by_ref >/dev/null; then
        _get_comp_words_by_ref -n : cur cword
    else
        cur="${COMP_WORDS[COMP_CWORD]}"
        cword=$COMP_CWORD
    fi

    if ((cword == 1)); then
        local IFS=$'\n'
        # shellcheck disable=SC2207
        COMPREPLY=($(compgen -W "$(artisan --commands 2>/dev/null | cut -f1)"$'\n--commands\n--refresh' -- "$cur"))
        declare -F __ltrim_colon_completions >/dev/null && __ltrim_colon_completions "$cur"
    elif ((cword == 2)) && [ "${COMP_WORDS[1]}" = --commands ]; then
        # shellcheck disable=SC2207
        COMPREPLY=($(compgen -W --json -- "$cur"))
    fi
}

complete -o default -F _artisan artisan
