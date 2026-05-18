{
    flake.modules.homeManager.core = {config, ...}: {
        home.sessionPath = ["${config.home.homeDirectory}/.local/bin"];
        home.shellAliases = {
            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../..";
            "....." = "cd ../../../..";
            ":q" = "exit";
            dl = "cd ${config.home.homeDirectory}/Downloads";
            dt = "cd ${config.home.homeDirectory}/Desktop";
            cf = "cd ${config.home.homeDirectory}/.config";
            nc = "cd ${config.home.homeDirectory}/nix-config";
            ous = "cd ${config.home.homeDirectory}/ous/platform";
            dev = "cd ${config.home.homeDirectory}/dev";
            ls = "eza --color=always --long -a --git --icons=always";
            cat = "bat";
            dps = "docker ps";
        };
        programs.bash = {
            enable = true;
            initExtra = ''
                _c_fg_bold=$'\e[1;38;2;197;201;199m'  # #c5c9c7 — foreground
                _c_fg=$'\e[38;2;197;201;199m'         # #c5c9c7 — foreground
                _c_dim=$'\e[38;2;92;96;102m'          # #5c6066 — palette 8  (dim/comments)
                _c_dimmer=$'\e[38;2;164;167;164m'     # #a4a7a4 — palette 7  (mid grey)
                _c_blue=$'\e[38;2;139;164;176m'       # #8ba4b0 — palette 4  (branch)
                _c_yellow=$'\e[38;2;196;178;138m'     # #c4b28a — palette 3  (dirty)
                _c_reset=$'\e[0m'

                _sep() {
                    printf "''${_c_dimmer}    ''${_c_reset}"
                }

                _pwd() {
                    local pwd="''${PWD/#$HOME/\~}"
                    if git rev-parse --is-inside-work-tree &>/dev/null; then
                        local root
                        root=$(git rev-parse --show-toplevel 2>/dev/null)
                        local repo_name
                        repo_name=$(basename "$root")
                        local rel
                        rel="''${PWD#$root}"
                        printf '%s%s' "$repo_name" "$rel"
                    else
                        local parts
                        IFS='/' read -ra parts <<< "$pwd"
                        local count=''${#parts[@]}
                        if [[ $count -gt 3 ]]; then
                            printf '…/%s/%s' "''${parts[$count-2]}" "''${parts[$count-1]}"
                        else
                            printf '%s' "$pwd"
                        fi
                    fi
                }

                _git() {
                    git rev-parse --is-inside-work-tree &>/dev/null || return

                    local branch
                    branch=$(git symbolic-ref --short HEAD 2>/dev/null \
                             || git rev-parse --short HEAD 2>/dev/null)

                    local dirty
                    dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

                    _sep
                    printf "''${_c_blue}%s''${_c_reset}" "$branch"

                    if [[ $dirty -gt 0 ]]; then
                        printf " ''${_c_yellow}±%s''${_c_reset}" "$dirty"
                    fi
                }

                _prompt() {
                    if [[ $_first_prompt -eq 1 ]]; then
                        _first_prompt=0
                    else
                        printf '\n'
                    fi

                    printf "''${_c_fg_bold}%s''${_c_reset}" "$USER"
                    printf "''${_c_dim}@%s''${_c_reset}" "''${HOSTNAME%%.*}"

                    _sep
                    printf "''${_c_fg}%s''${_c_reset}" "$(_pwd)"

                    _git

                    printf '\n'
                }

                _first_prompt=1
                PROMPT_COMMAND='_prompt'
                PS1=$'\[\e[1;38;2;197;201;199m\]󰘧 \[\e[0m\]'

                export PROMPT_COMMAND
            '';
        };
        xdg.configFile."brush/config.toml".text = ''
            #:schema https://raw.githubusercontent.com/reubeno/brush/main/schemas/config.schema.json
            [ui]
            syntax-highlighting = true
            [experimental]
            terminal-shell-integration = true
        '';
    };
}
