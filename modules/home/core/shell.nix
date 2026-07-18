{config, ...}: let
    users = config.flake.meta.users;
    home = "/home/${users.primary}";
in {
    flake.modules.hjem.core = {pkgs, ...}: let
        # Program binaries whose fish integration was previously wired by
        # home-manager's `enableFishIntegration`. Referenced by store path so
        # they resolve regardless of PATH ordering.
        atuin = "${pkgs.atuin}/bin/atuin";
        fzf = "${pkgs.fzf}/bin/fzf";
        direnv = "${pkgs.direnv}/bin/direnv";

        aliases = {
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
        };

        aliasLines = builtins.concatStringsSep "\n" (
            builtins.attrValues (builtins.mapAttrs (name: cmd: "alias ${name} ${pkgs.lib.escapeShellArg cmd}") aliases)
        );

        mkFunction = name: body: {
            "fish/functions/${name}.fish".text = ''
                function ${name}
                ${body}
                end
            '';
        };
    in {
        xdg.config.files =
            {
                "fish/config.fish".text = ''
                    fish_add_path ${home}/.local/bin

                    # Session variables (previously home.sessionVariables)
                    set -gx DIRENV_LOG_FORMAT ""
                    set -gx INTELEPHENSE_KEY_PATH /run/agenix/intelephense
                    # Disable fzf's Ctrl-R history widget; atuin owns Ctrl-R.
                    set -gx FZF_CTRL_R_COMMAND ""

                    if status is-interactive
                        ${aliasLines}

                        # Prompt / git-prompt configuration
                        set -g __fish_git_prompt_showdirtystate 1
                        set -g __fish_git_prompt_showuntrackedfiles 1
                        set -g __fish_git_prompt_showupstream auto

                        # fzf: keep Ctrl-T (files) and Alt-C (cd); atuin owns Ctrl-R.
                        ${fzf} --fish | source
                        bind --erase \cr 2>/dev/null

                        # atuin: history + Ctrl-R / up-arrow bindings.
                        ${atuin} init fish | source

                        # direnv hook
                        ${direnv} hook fish | source

                        # ghostty shell integration (when launched inside ghostty)
                        if set -q GHOSTTY_RESOURCES_DIR
                            source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
                        end
                    end
                '';

                # command-not-found handler (was onEvent = fish_command_not_found)
                "fish/functions/__fish_command_not_found_handler.fish".text = ''
                    function __fish_command_not_found_handler --on-event fish_command_not_found
                        __fish_default_command_not_found_handler $argv[1]
                    end
                '';

                # yazi wrapper (was programs.yazi shellWrapperName = "y")
                "fish/functions/y.fish".text = ''
                    function y
                        set -l tmp (mktemp -t "yazi-cwd.XXXXX")
                        command yazi $argv --cwd-file="$tmp"
                        if read cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                            builtin cd -- "$cwd"
                        end
                        rm -f -- "$tmp"
                    end
                '';

                # lazygit wrapper (was programs.lazygit enableFishIntegration)
                "fish/functions/lg.fish".text = ''
                    function lg
                        set -x LAZYGIT_NEW_DIR_FILE ~/.lazygit/newdir
                        command lazygit $argv
                        if test -f $LAZYGIT_NEW_DIR_FILE
                            cd (cat $LAZYGIT_NEW_DIR_FILE)
                            rm -f $LAZYGIT_NEW_DIR_FILE
                        end
                    end
                '';
            }
            // (mkFunction "music-import" ''
                ssh caligula@smiley.local "cd /data/downloads/complete/music && beet import ."'')
            // (mkFunction "_sep" ''
                set_color a4a7a4   # #a4a7a4 — mid grey (palette 7)
                printf '    '
                set_color normal'')
            // (mkFunction "_pwd" ''
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
                end'')
            // (mkFunction "_git" ''
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
                end'')
            // (mkFunction "fish_prompt" ''
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
                set_color normal'')
            // (mkFunction "claude-personal" ''
                CLAUDE_CONFIG_DIR=~/.claude-personal claude "$argv"'');
    };
}
