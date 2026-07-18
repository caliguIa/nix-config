{
    flake.modules.hjem.core = {
        config,
        pkgs,
        lib,
        ...
    }: let
        inherit (lib.attrsets) mapAttrsToList;
        inherit (lib.meta) getExe;
        inherit (lib.strings) concatLines escapeShellArg;

        home = config.directory;

        atuin = getExe pkgs.atuin;
        fzf = getExe pkgs.fzf;
        direnv = getExe pkgs.direnv;

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

        aliasLines = concatLines (
            mapAttrsToList (name: cmd: "alias ${name} ${escapeShellArg cmd}") aliases
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

                    set -gx DIRENV_LOG_FORMAT ""
                    set -gx INTELEPHENSE_KEY_PATH /run/agenix/intelephense
                    set -gx FZF_CTRL_R_COMMAND ""

                    if status is-interactive
                        ${aliasLines}

                        set -g __fish_git_prompt_showdirtystate 1
                        set -g __fish_git_prompt_showuntrackedfiles 1
                        set -g __fish_git_prompt_showupstream auto

                        # atuin owns Ctrl-R; fzf keeps Ctrl-T and Alt-C.
                        ${fzf} --fish | source
                        bind --erase \cr 2>/dev/null
                        ${atuin} init fish | source
                        ${direnv} hook fish | source

                        if set -q GHOSTTY_RESOURCES_DIR
                            source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
                        end
                    end
                '';

                "fish/functions/__fish_command_not_found_handler.fish".text = ''
                    function __fish_command_not_found_handler --on-event fish_command_not_found
                        __fish_default_command_not_found_handler $argv[1]
                    end
                '';

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
