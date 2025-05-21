{...}: {
    programs.tmux = {
        enable = true;
        sensibleOnTop = false;
        extraConfig = ''
            # Unbind default keys
            unbind C-b
            unbind '"'
            unbind %

            # remap prefix from 'C-b' to 'C-space'
            set -g prefix C-space
            bind C-space send-prefix

            set -g mouse on
            set -g mode-keys vi

            # Undercurl
            # set -g default-terminal "tmux-256color"
            set -g default-terminal 'xterm-ghostty'
            set -gas terminal-overrides "*:Tc" # true color support
            set -gas terminal-overrides "*:RGB" # true color support
            # set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
            # set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

            # Status bar
            set -g status-style bg=#121212,fg=#f5f5f5

            set -g status-left ' #S - '
            set -g status-right '#[fg=#f5f5f5]#(whoami)#[fg=#ff0088]@#[fg=#949494]#(hostname -s) '

            # Windows
            setw -g window-status-format '#I:#W '
            setw -g window-status-style fg=#949494
            setw -g window-status-current-style fg=#f5f5f5,bold
            setw -g window-status-current-format '#[fg=#f5f5f5]#I:#W '

            # Panes
            set -g pane-border-style 'fg=#323232'
            set -g pane-active-border-style 'fg=#323232'

            # set -g default-shell $HOME/.nix-profile/bin/zsh
            # set -g default-shell $HOME/.nix-profile/bin/zsh
            # set -g default-command $HOME/.nix-profile/bin/zsh
            set -g status-position top
            set -g base-index 1
            set -g pane-base-index 1

            set -g history-limit 50000

            # Remove Vim mode delays
            set -g escape-time 10
            set -g focus-events on
            set -g status-left-length 90
            set -g status-right-length 90
            set -g status-justify left

            # -----------------------------------------------------------------------------
            # Key bindings
            # -----------------------------------------------------------------------------
            bind Enter copy-mode
            bind -T copy-mode-vi v send -X begin-selection
            bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
            bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

            # Split panes, vertical or horizontal
            bind x split-window -v
            bind v split-window -h

            # Move around panes with vim-like bindings (h,j,k,l)
            bind k select-pane -U
            bind h select-pane -L
            bind j select-pane -D
            bind l select-pane -R

            # bind t popup -E "tmux new-session -A -s scratch \\\; set -t scratch status off"
            bind r source-file $HOME/.config/tmux/tmux.conf
            bind S command-prompt -p "New Session:" "new-session -A -s '%%'"
            bind K confirm kill-session

            bind e popup -E "tmux-cmd-launcher.sh"

            # Smart pane switching with awareness of Vim splits.
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
}
