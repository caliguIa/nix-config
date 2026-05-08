{
    flake.modules.homeManager.core = {
        programs.fish = {
            enable = true;
            generateCompletions = true;
            interactiveShellInit = ''
                test -f ~/.local/auth/fish_env.fish; and source ~/.local/auth/fish_env.fish

                set -g __fish_git_prompt_showdirtystate 1
                set -g __fish_git_prompt_showuntrackedfiles 1
                set -g __fish_git_prompt_showupstream auto

                set -g USG_FG     1a1a18
                set -g USG_DIM    888886
                set -g USG_DIMMER b0afad
                set -g USG_GREEN  1a6b3c
                set -g USG_RED    b83225
                set -g USG_YELLOW 9a6e00
                set -g USG_BLUE   1a3e6b
            '';
            functions = {
                fish_prompt = ''
                    set -l last_exit $status   # capture immediately, before anything else

                    # blank line between prompts, but not on first load
                    if set -q _usg_prompt_shown
                        echo
                    else
                        set -g _usg_prompt_shown 1
                    end

                    # user@host
                    set_color $USG_FG --bold
                    printf '%s' (whoami)
                    set_color normal
                    set_color $USG_DIM
                    printf '@%s' (prompt_hostname)
                    set_color normal

                    # cwd
                    _sep
                    set_color $USG_FG
                    printf '%s' (prompt_pwd --full-length-dirs 2 -d 1)
                    set_color normal

                    # git (only if inside a repo)
                    _usg_git

                    # exit code
                    _sep
                    _key 'exit '
                    if test $last_exit -eq 0
                        set_color $USG_GREEN
                    else
                        set_color $USG_RED
                    end
                    printf '%d' $last_exit
                    set_color normal

                    # duration (skipped on first load when CMD_DURATION is 0)
                    _usg_dur $CMD_DURATION

                    # command row
                    echo
                    set_color $USG_FG --bold
                    printf ' '
                    set_color normal
                '';
                fish_greeting = "";
                fish_mode_prompt = "";
                fish_right_prompt = "";
                _usg_dur = ''
                    set ms $argv[1]

                    # on first load CMD_DURATION is 0 or empty — show nothing
                    if test -z "$ms" -o "$ms" -le 0
                        return
                    end

                    _sep
                    _key 'dur '
                    set_color $USG_DIM
                    if test $ms -lt 1000
                        printf '%dms' $ms
                    else if test $ms -lt 60000
                        printf '%ss' (math --scale=1 $ms / 1000)
                    else
                        printf '%dm%ds' (math --scale=0 $ms / 60000) (math --scale=0 "$ms % 60000 / 1000")
                    end
                    set_color normal
                '';
                _usg_git = ''
                    # returns early (no output) if not in a repo — no separator printed
                    git rev-parse --is-inside-work-tree &>/dev/null
                    or return

                    set branch (git symbolic-ref --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)

                    set dirty (git status --porcelain 2>/dev/null | count)

                    _sep
                    _key 'git '
                    set_color $USG_BLUE
                    printf '%s' $branch

                    if test $dirty -gt 0
                        set_color normal
                        printf ' '
                        set_color $USG_YELLOW
                        printf '±%s' $dirty
                    end

                    set_color normal
                '';
                _key = ''
                    set_color $USG_DIM
                    printf '%s' $argv[1]
                    set_color normal
                '';
                _sep = ''
                    set_color $USG_DIMMER
                    printf '  │  '
                    set_color normal
                '';
            };
        };
        home.sessionPath = [
            "/home/caligula/.local/bin"
        ];
        home.shellAliases = {
            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../..";
            "....." = "cd ../../../..";
            ":q" = "exit";
            dl = "cd ~/Downloads";
            dt = "cd ~/Desktop";
            cf = "cd ~/.config";
            ous = "cd ~/ous/platform";
            dev = "cd ~/dev";
            ls = "eza --color=always --long -a --git --icons=always";
            cat = "bat";
            dps = "docker ps";
        };
    };
}
