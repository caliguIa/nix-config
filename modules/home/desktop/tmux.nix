{self, ...}: {
    flake.modules.homeManager.desktop = {
        pkgs,
        config,
        ...
    }: let
        themeConfig = import (self + /utils/colours);
        colours = themeConfig.tmux;
        copyCmd =
            if pkgs.stdenvNoCC.isDarwin
            then "pbcopy"
            else "wl-copy";
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

                set -g status-style bg=${colours.status_bg},fg=${colours.status_fg}

                set -g status-left ' #S - '
                set -g status-right '#[fg=${colours.status_fg}]#(whoami)#[fg=${colours.window_status_current_fg}]@#[fg=${colours.status_fg}]#(hostname -s) '

                setw -g window-status-format '#I:#W '
                setw -g window-status-style fg=${colours.window_status_fg}
                setw -g window-status-current-style fg=${colours.window_status_current_fg},bold
                setw -g window-status-current-format '#[fg=${colours.window_status_current_fg}]#I:#W '

                set -g pane-border-style 'fg=${colours.pane_border_fg}'
                set -g pane-active-border-style 'fg=${colours.pane_active_border_fg}'

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
                bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${copyCmd}"
                bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "${copyCmd}"

                bind h split-window -v
                bind v split-window -h

                bind g display-popup -w 90% -h 90% -E "gitu"
                bind d display-popup -w 95% -h 95% -E "rainfrog"
                bind t popup -E "tmux new-session -A -s scratch \\\; set -t scratch status off"
                bind f display-popup -E "tms"
                bind s display-popup -E "tms switch"
                bind w display-popup -E "tms windows"
                bind r command-prompt -p "Rename active session to: " "run-shell 'tms rename %1'".
                bind R source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"
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
        home.shellAliases = {
            t = "tmux attach-session";
        };
        home.packages = with pkgs; [
            tmux-sessionizer
            (writeScriptBin "tmux-cmd-launcher.sh" ''
                commands=(
                    "nix rebuild::cd ~/nix-config; just build"
                    "nix update::cd ~/nix-config; just update"
                    "nix gc::sudo nh clean all; nh clean all"
                    "jira view sprint::jira sprint list $JIRA_SPRINT -a$(jira me) --order-by status --reverse"
                    "jira set sprint::jira-set-sprint.sh"
                    "ous bounce::cd ~/ous; make down; make platform-up"
                    "ous down::cd ~/ous; make down"
                    "ous up::cd ~/ous; make platform-up"
                    "pr review::prr-review.sh"
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
            '')
            (writeScriptBin "jira-set-sprint.sh" ''
                sprints=$(jira sprint list --table --plain --columns id,name --state active)
                if [ -z "$sprints" ]; then
                    echo "No active sprints found"
                    exit 1
                fi
                selected=$(echo "$sprints" | fzf --header="Select a sprint to set as current")
                if [ -z "$selected" ]; then
                    echo "No sprint selected"
                    exit 0
                fi
                sprint_id=$(echo "$selected" | awk '{print $1}')
                echo "Setting sprint $sprint_id as current"
                if [ -f ~/.local/auth/fish_env.fish ]; then
                    # Remove existing JIRA_SPRINT line if it exists
                    grep -v "^set -gx JIRA_SPRINT" ~/.local/auth/fish_env.fish > ~/.local/auth/fish_env.fish.tmp
                    mv ~/.local/auth/fish_env.fish.tmp ~/.local/auth/fish_env.fish
                fi
                echo "set -gx JIRA_SPRINT $sprint_id" >> ~/.local/auth/fish_env.fish
                echo "Successfully set JIRA_SPRINT to $sprint_id in ~/.local/auth/fish_env.fish"
            '')
            (writeScriptBin "prr-review.sh" ''
                prs=$(gh pr list --state open --json number,title,author --template '{{range .}}{{.number}}	{{.title}}	{{.author.login}}{{"\n"}}{{end}}')
                if [ -z "$prs" ]; then
                    echo "No open PRs found in this repository"
                    exit 1
                fi
                selected=$(echo "$prs" | fzf --with-nth=2.. --delimiter=$'\t' --preview 'gh pr view {1}' --header="Select a PR to review")
                if [ -z "$selected" ]; then
                    echo "No PR selected"
                    exit 0
                fi
                pr_number=$(echo "$selected" | cut -f1)
                echo "Selected PR #$pr_number"
                if prr status | grep -q "^$pr_number\s"; then
                    echo "PR #$pr_number already exists locally, opening editor..."
                    prr edit "$pr_number"
                else
                    echo "PR #$pr_number not found locally, fetching..."
                    if prr get "$pr_number"; then
                        echo "Successfully fetched PR #$pr_number, opening editor..."
                        prr edit "$pr_number"
                    else
                        echo "Failed to fetch PR #$pr_number"
                        exit 1
                    fi
                fi
            '')
        ];
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
            bookmarks = ["${config.home.homeDirectory}/ous/platform"]
            [[search_dirs]]
            path = "${config.home.homeDirectory}"
            depth = 3
        '';
    };
}
