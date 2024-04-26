{ pkgs, ... }: {
  enable = true;
  keyMode = "vi";
  mouse = true;
  clock24 = true;
  baseIndex = 1;
  prefix = "C-space";
  escapeTime = 10;
  historyLimit = 50000;
  plugins = with pkgs.tmuxPlugins; [ sensible yank ];
  extraConfig = ''
    #set -ag terminal-overrides ",xterm-256color:RGB"
    #set-option -sa terminal-features ',alacritty:RGB'
    #set-option -ga terminal-features ",alacritty:usstyle"

    # Undercurl
    set -g default-terminal "tmux-256color"
    set-option -gas terminal-overrides "*:Tc" # true color support
    set-option -gas terminal-overrides "*:RGB" # true color support
    set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
    set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

    set -sg escape-time 10
    set -g focus-events on
    set-option -g status "off"

    # Remove Vim mode delays
    set -g focus-events on
    set -g status-left-length 90
    set -g status-right-length 90
    set -g status-justify centre

    # -----------------------------------------------------------------------------
    # Key bindings
    # -----------------------------------------------------------------------------

    # Unbind default keys
    unbind C-b
    unbind '"'
    unbind %

    # Split panes, vertical or horizontal
    bind-key x split-window -v
    bind-key v split-window -h

    # Move around panes with vim-like bindings (h,j,k,l)
    bind-key k select-pane -U
    bind-key h select-pane -L
    bind-key j select-pane -D
    bind-key l select-pane -R
    bind-key g display-popup -w 90% -h 90% "gitui"
    bind-key t display-popup -E "tmux new-session -A -s scratch"
    bind-key o display-popup -E "tms"
    bind-key s display-popup -E "tms switch"
    bind-key w display-popup -E "tms windows"
    bind-key r command-prompt -p "Rename active session to: " "run-shell 'tms rename %1'"
    bind-key q confirm-before -p "Kill session (y/n): " "tms kill"
  '';
}
