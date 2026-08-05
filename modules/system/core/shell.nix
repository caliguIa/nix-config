{user, ...}: {
    flake.modules.nixos.core = {
        config,
        pkgs,
        lib,
        ...
    }: let
        inherit (lib.attrsets) mapAttrsToList;
        inherit (lib.strings) concatStringsSep;

        home = config.users.users.${user.primary}.home;
    in {
        users.defaultUserShell = pkgs.fish;
        users.users.${user.primary}.shell = pkgs.fish;
        environment = {
            shells = [pkgs.fish];
            variables = {
                EDITOR = "nvim";
                VISUAL = "nvim";
                XDG_CACHE_HOME = "${home}/.cache";
                XDG_CONFIG_HOME = "${home}/.config";
                XDG_DATA_HOME = "${home}/.local/share";
            };
            systemPackages = [pkgs.ghostty.terminfo];
            pathsToLink = ["${home}/.local/bin" "${home}/.cargo/bin"];
        };
        programs.fzf.keybindings = true;
        programs.atuin = {
            enable = true;
            enableFishIntegration = true;
            settings = {
                dialect = "uk";
                auto_sync = true;
                update_check = true;
                sync_frequency = "5m";
                sync_address = "https://api.atuin.sh";
            };
        };
        programs.fish = let
            functions = {
                music-import = ''ssh -t smiley beets-import'';

                _sep = ''
                    set_color white
                    printf '    '
                    set_color normal'';

                _pwd = ''
                    if set -l root (git rev-parse --show-toplevel 2>/dev/null)
                      printf '%s%s' (basename "$root") (string replace -- "$root" "" $PWD)
                    else
                      set -l parts (string split / -- (prompt_pwd --dir-length 0))
                      if test (count $parts) -gt 3
                        printf '…/%s/%s' $parts[-2] $parts[-1]
                      else
                        string join / $parts
                      end
                    end'';

                fish_prompt = ''
                    if set -q __prompt_seen
                      echo
                    else
                      set -g __prompt_seen 1
                    end
                    set_color --bold brwhite
                    printf '%s' $USER
                    set_color normal
                    set_color brblack
                    printf '@%s' (prompt_hostname)
                    set_color normal
                    _sep
                    set_color brwhite
                    printf '%s' (_pwd)
                    set_color normal
                    fish_git_prompt (_sep)'%s'
                    echo
                    set_color --bold brwhite
                    printf '󰘧 '
                    set_color normal'';

                claude-personal = ''CLAUDE_CONFIG_DIR=~/.claude-personal claude "$argv"'';
            };

            mkFunctions = concatStringsSep "\n\n" (
                mapAttrsToList (name: body: ''
                    function ${name}
                    ${body}
                    end'')
                functions
            );
        in {
            enable = true;
            shellAliases = {
                ".." = "cd ..";
                "..." = "cd ../..";
                "...." = "cd ../../..";
                "....." = "cd ../../../..";
                ":q" = "exit";
                dl = "cd ${home}/Downloads";
                dt = "cd ${home}/Desktop";
                cf = "cd ${home}/.config";
                nc = "cd ${home}/nix-config";
                ous = "cd ${home}/ous/platform";
                starrocks = "cd ${home}/ous/starrocks";
                dev = "cd ${home}/dev";
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
                y = "yazi";
                lg = "lazygit";
            };
            shellInit = ''
                # set -gx FZF_CTRL_R_COMMAND ""
                set -gx INTELEPHENSE_KEY_PATH /run/agenix/intelephense
                source "${pkgs.ghostty}/share/ghostty/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
            '';
            interactiveShellInit = ''
                set -g __fish_git_prompt_show_informative_status 1
                set -g __fish_git_prompt_showdirtystate 1
                set -g __fish_git_prompt_showuntrackedfiles 1
                set -g __fish_git_prompt_showupstream auto

                # layout: separator + branch, then dirty/staged/untracked marks
                set -g __fish_git_prompt_char_stateseparator ' '
                set -g __fish_git_prompt_color_branch blue
                set -g __fish_git_prompt_color_dirtystate yellow
                set -g __fish_git_prompt_color_stagedstate yellow
                set -g __fish_git_prompt_color_untrackedfiles yellow
                set -g __fish_git_prompt_char_dirtystate '±'
                set -g __fish_git_prompt_char_stagedstate '+'
                set -g __fish_git_prompt_char_untrackedfiles '?'

                ${mkFunctions}
            '';
        };
    };
}
