{...}: {
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

            set -g status-style bg=#333333,fg=#C2C2C2

            set -g status-left ' #S - '
            set -g status-right '#[fg=#C2C2C2]#(whoami)#[fg=#CCCCCC]@#[fg=#C2C2C2]#(hostname -s) '

            setw -g window-status-format '#I:#W '
            setw -g window-status-style fg=#C2C2C2
            setw -g window-status-current-style fg=#C2C2C2,bold
            setw -g window-status-current-format '#[fg=#C2C2C2]#I:#W '

            set -g pane-border-style 'fg=#868686'
            set -g pane-active-border-style 'fg=#868686'

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
            bind K confirm-before -p "Kill current session? (y/n): " "run-shell 'tms kill'"
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

    home.file.".local/bin/tmux-cmd-launcher.sh" = {
        source = ./tmux-cmd-launcher.sh;
        executable = true;
    };
}
