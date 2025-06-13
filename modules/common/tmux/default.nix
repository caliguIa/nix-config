{pkgs, ...}: let
    themeConfig = import ../themes;
    tmux = themeConfig.tmux;
in {
    programs.tmux = {
        enable = true;
        sensibleOnTop = false;
        extraConfig = ''
            unbind C-b
            unbind '"'
            unbind %

            set -g prefix C-space
            bind C-space send-prefix

            set -g mouse on
            set -g mode-keys vi

            # Undercurl
            set -g default-terminal 'xterm-ghostty'
            set -gas terminal-overrides "*:Tc" # true color support
            set -gas terminal-overrides "*:RGB" # true color support

            set -g status-style bg=${tmux.status_bg},fg=${tmux.status_fg}

            set -g status-left ' #S - '
            set -g status-right '#[fg=${tmux.status_fg}]#(whoami)#[fg=${tmux.window_status_current_fg}]@#[fg=${tmux.status_fg}]#(hostname -s) '

            setw -g window-status-format '#I:#W '
            setw -g window-status-style fg=${tmux.window_status_fg}
            setw -g window-status-current-style fg=${tmux.window_status_current_fg},bold
            setw -g window-status-current-format '#[fg=${tmux.window_status_current_fg}]#I:#W '

            set -g pane-border-style 'fg=${tmux.pane_border_fg}'
            set -g pane-active-border-style 'fg=${tmux.pane_active_border_fg}'

            set -g status-position top
            set -g base-index 1
            set -g pane-base-index 1

            set -g history-limit 50000

            set -g escape-time 10
            set -g focus-events on
            set -g status-left-length 90
            set -g status-right-length 90
            set -g status-justify left

            bind Enter copy-mode
            bind -T copy-mode-vi v send -X begin-selection
            bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
            bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

            bind h split-window -v
            bind v split-window -h

            bind t popup -E "tmux new-session -A -s scratch \\\; set -t scratch status off"
            bind f display-popup -E "tms"
            bind s display-popup -E "tms switch"
            bind w display-popup -E "tms windows"
            bind r command-prompt -p "Rename active session to: " "run-shell 'tms rename %1'".
            bind k confirm-before -p "Kill current session? (y/n): " "run-shell 'tms kill'"
            bind x kill-pane

            bind e popup -E "tmux-cmd-launcher.sh"

            is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
                | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
            bind -n 'M-h' if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
            bind -n 'M-j' if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
            bind -n 'M-k' if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
            bind -n 'M-l' if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'

            bind -T copy-mode-vi 'M-h' select-pane -L
            bind -T copy-mode-vi 'M-j' select-pane -D
            bind -T copy-mode-vi 'M-k' select-pane -U
            bind -T copy-mode-vi 'M-l' select-pane -R
        '';
    };
    home.file.".local/bin/tmux-cmd-launcher.sh" = {
        text = toString (pkgs.writeShellScript "newsboat-url" ''
            commands=(
                "ous bounce::cd ~/ous; make down; make platform-up"
                "ous down::cd ~/ous; make down"
                "ous up::cd ~/ous; make platform-up"
                "nix rebuild::cd ~/nix-config; just build"
                "nix gc::nix-store --gc; nix-collect-garbage -d; sudo nix-collect-garbage --delete-old; nix-env --delete-generations old; sudo nix-store -gc; sudo nix-collect-garbage -d; nix store gc; sudo nix store gc"
            )
            selected=$(printf '%s\n' "''${commands[@]}" | cut -d':' -f1 | fzf)
            if [ -n "$selected" ]; then
                for cmd in "''${commands[@]}"; do
                    if [[ $cmd == ''${selected}::* ]]; then
                        command="''${cmd#*::}"
                        # Create a new pane and run the command
                        tmux split-window -h "eval '$command'; echo 'Press any key to exit...'; read -n 1"
                        exit 0
                    fi
                done
            fi
        '');
        executable = true;
    };
    xdg.configFile."tms/config.toml".text = ''
        display_full_path = false
        search_submodules = false
        recursive_submodules = false
        excluded_dirs = [
            "Applications",
            "build",
            "tmp",
            "Desktop",
            "Downloads",
            "Documents",
            "Music",
            "Library",
            "go",
            "Pictures",
            "Public",
            "Spitfire",
            "ous",
            "games",
            ".git",
            ".nix-profile",
            ".local",
            ".swiftpm",
            ".cache",
        ]
        bookmarks = ["/Users/caligula/ous/platform"]
        [[search_dirs]]
        path = "/Users/caligula"
        depth = 3
    '';
}
