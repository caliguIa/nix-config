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
            dcu = "docker compose up -d";
            dcua = "docker compose up";
            dash = "gh dash";
            ga = "git add";
            gaa = "git add .";
            gap = "git add --patch";
            gb = "git branch";
            gc = "git commit";
            gd = "git diff";
            gi = "git init";
            gst = "git status";
            gs = "git switch";
            gn = "git switch -c";
            gp = "git push";
            gu = "git pull";
            gfp = "git fetch --all --prune && git pull";
            gcl = "git clone";
            gmm = "git merge origin/main";
            undocommit = "git reset --soft HEAD^";
        };

        programs.fish = {
            enable = true;
            generateCompletions = true;
            interactiveShellInit = ''
                set -g __fish_git_prompt_showdirtystate 1
                set -g __fish_git_prompt_showuntrackedfiles 1
                set -g __fish_git_prompt_showupstream auto
            '';
            functions = {
                __fish_command_not_found_handler = {
                    body = "__fish_default_command_not_found_handler $argv[1]";
                    onEvent = "fish_command_not_found";
                };
                music-import = ''ssh caligula@smiley.local "cd /data/downloads/complete/music && beet import ."'';
                _sep = ''
                    set_color a4a7a4   # #a4a7a4 — mid grey (palette 7)
                    printf '    '
                    set_color normal
                '';
                _pwd = ''
                    set -l pwd (string replace -r "^$HOME" '~' -- $PWD)
                    if git rev-parse --is-inside-work-tree &>/dev/null
                      set -l root (git rev-parse --show-toplevel 2>/dev/null)
                      printf '%s%s' (basename "$root") (string replace -- "$root" "" $PWD)
                    else
                      set -l parts (string split / -- $pwd)
                      if test (count $parts) -gt 3
                        printf '…/%s/%s' $parts[-2] $parts[-1]
                      else
                        printf '%s' $pwd
                      end
                    end
                '';
                _git = ''
                    git rev-parse --is-inside-work-tree &>/dev/null; or return
                    set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
                    set -l dirty (count (git status --porcelain 2>/dev/null))
                    _sep
                    set_color 8ba4b0   # #8ba4b0 — branch (palette 4)
                    printf '%s' $branch
                    set_color normal
                    if test $dirty -gt 0
                      set_color c4b28a # #c4b28a — dirty (palette 3)
                      printf ' ±%s' $dirty
                      set_color normal
                    end
                '';
                fish_prompt = ''
                    if set -q __prompt_seen
                      echo
                    else
                      set -g __prompt_seen 1
                    end
                    set_color --bold c5c9c7      # #c5c9c7 — foreground (bold)
                    printf '%s' $USER
                    set_color normal
                    set_color 5c6066             # #5c6066 — dim (palette 8)
                    printf '@%s' (string split -f1 . $hostname)
                    set_color normal
                    _sep
                    set_color c5c9c7             # #c5c9c7 — foreground
                    printf '%s' (_pwd)
                    set_color normal
                    _git
                    echo
                    set_color --bold c5c9c7
                    printf '󰘧 '
                    set_color normal
                '';
                claude-personal = ''
                    CLAUDE_CONFIG_DIR=~/.claude-personal claude "$argv"
                '';
            };
        };
    };
}
