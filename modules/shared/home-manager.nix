{ config, pkgs, ... }:

let
  name = "Cal";
  email = "accounts@cal.rip";
in
{
  zsh = {
    enable = true;
    autocd = false;
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "docker"
        "docker-compose"
        "fd"
        "fnm"
        "gcloud"
        "gh"
        "git"
        "node"
        "ripgrep"
        "rsync"
        "rust"
        "terraform"
        "tmux"
      ];
      theme = "frisk";
    };
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    dotDir = ".config/zsh";

    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # PATH
      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=$HOME/.cargo/bin:$PATH
      export PATH=$HOME/.local/share/fnm:$PATH
      export PATH=$HOME/.local/bin:$PATH
      #export PATH  =/opt/homebrew/bin:$PATH


      #ENVARS
      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"
      #export SHELL="/bin/zsh"
      export GCLOUD_CONFIG_HOME=/Users/caligula/.config/gcloud
      export PROJECT_ID="panda-development"
      export DEV_STORAGE_SERVICE=/Users/caligula/.config/auth/panda-development-1af3ae8f0648.json
      export EDITOR="nvim"
      export FIREBASE_PROJECT="panda-dev-cal-local"
      export FIREBASE_AUTH_CREDENTIALS=/Users/caligula/.config/auth/panda-dev-cal-local-c0d2a21988b5.json
      export SSL_LOCAL_PREFIX=/Users/caligula/.ssl/ssl/
      export ZDOTDIR=/Users/caligula/.config/zsh
      export HISTFILE=/Users/caligula/.config/zsh/.zsh_history setopt appendhistory
      export BUILD_VERSION=0
      export LOCAL=1

      # FUNCTIONS
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      stream() {
        ffmpeg -re -stream_loop -1 \
          -r 30 \
          -f lavfi \
          -i testsrc \
          -vf scale=1920:1080 \
          -c:v libx264 \
          -c:a aac \
          -f flv rtmp://stream.smartzer.com:5222/app/$1
      }

      kills() {
        echo "Stopping smrtzr shit"
        echo "Killing all java processes"
        pkill -f "java"
        echo "Killing all webpack processes"
        pkill -f "webpack"
        echo "Killing ports"
        killport 8484 8079 8082 8888 8893 8890 8090 8091 8894 8892 8492 8895 8896 8889
      }

      nixmv() {
        sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
        sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
        sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
      }

      # ALIASES

      alias diff=difft
      alias ~='cd ~';
      alias dl="cd ~/Downloads";
      alias dt="cd ~/Desktop";
      alias df="cd ~/nixos-config";
      alias cf="cd ~/.config";
      alias dev="cd ~/dev";
      alias ..="cd ..";
      alias ...="cd ../..";
      alias ....="cd ../../..";
      alias ls="eza -la";
      alias empty="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'";
      alias cat="bat";
      alias cp="cp -i";
      alias mv="mv -i";
      alias g="git";
      alias ga="git add";
      alias gaa="git add --all";
      alias gst="git status";
      alias gac="git add .; git commit";
      alias gco="git checkout";
      alias gs="git switch";
      alias gfp="git fetch && git pull";
      alias undocommit="git reset --soft HEAD^";
      alias dc="docker-compose";
      alias dcu="docker-compose up";
      alias dcb="docker-compose build";
      alias dps="docker ps";
      alias ip="curl ifconfig.io";
      alias localip="ipconfig getifaddr en0";
      alias update="softwareupdate -ia";
      alias updatel="softwareupdate -l";
      alias t="tmux attach || tmux new";
      alias tks="tmux kill-server";
      alias vim="nvim";
      alias vi="nvim";
      alias smp="tmuxinator start players";
      alias mono="tmuxinator start mono";
      alias r18="tmuxinator start r18";
      alias smrtzr="cd ~/smrtzr/smrtzr/";
      alias players="cd ~/smrtzr/players/";
      alias :q="exit";
      alias fuck="echo 'Running: \e[32msudo \e[35m\e[4m\$(fc -ln -1)\e[0m' && sudo \$(fc -ln -1)";
      alias nixbs="cd ~/nixos-config; git add .; nix run .#build-switch";
      alias pe="./gradlew run";
      alias ds="./startDatastore.sh";
      alias gitui="gitui -t mocha.ron";

      eval "$(fnm env --use-on-cd)"

      source $HOME/.config/zsh/env-vars.local.zsh
    '';
  };

  git = {
    enable = true;
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
      };
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        symlinks = true;
        autocrlf = "input";
      };
      push.autoSetupRemote = true;
    };
    ignores = [
      "env-vars.private.zsh"
      "*.pyc"
      ".DS_Store"
      "Desktop.ini"
      "._*"
      "Thumbs.db"
      ".Spotlight-V100"
      ".Trashes"
      ".vscode"
      "luac.out"
      "*.src.rock"
      "*.zip"
      "*.tar.gz"
      "*.o"
      "*.os"
      "*.ko"
      "*.obj"
      "*.elf"
      "*.gch"
      "*.pch"
      "*.lib"
      "*.a"
      "*.la"
      "*.lo"
      "*.def"
      "*.exp"
      "*.dll"
      "*.so"
      "*.so.*"
      "*.dylib"
      "*.exe"
      "*.out"
      "*.app"
      "*.i*86"
      "*.x86_64"
      "*.hex"
      ".zsh_history"
      "zsh/.config/zsh/plugins/"
      "zsh/.config/zsh/env-vars.local.zsh"
      "nu/Library/Application Support/nu/envars-local.nu"
    ];
  };

  alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Block";
      };

      window = {
        opacity = 0.88;
        blur = true;
        decorations = "none";
        startup_mode = "Maximized";
        padding = {
          x = 4;
          y = 4;
        };
      };

      font = {
        normal = {
          family = "BerkeleyMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "BerkeleyMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "BerkeleyMono Nerd Font";
          style = "Italic";
        };
        size = 14.0;
      };

      colors = {
        primary = {
          background = "0x16181a";
          foreground = "0xffffff";
          #  background = "#1E1E2E";
          #  foreground = "#CDD6F4";
          dim_foreground = "#CDD6F4";
          bright_foreground = "#CDD6F4";
        };
        cursor = {
          text = "#1E1E2E";
          cursor = "#F5E0DC";
        };
        selection = {
          text = "#1E1E2E";
          background = "#F5E0DC";
        };
        search.matches = {
          foreground = "#1E1E2E";
          background = "#A6ADC8";
        };
        search.focused_match = {
          foreground = "#1E1E2E";
          background = "#A6E3A1";
        };
        footer_bar = {
          foreground = "#1E1E2E";
          background = "#A6ADC8";
        };
        hints.start = {
          foreground = "#1E1E2E";
          background = "#F9E2AF";
        };
        hints.end = {
          foreground = "#1E1E2E";
          background = "#A6ADC8";
        };
        normal = {
          black = "#45475A";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#BAC2DE";
        };
        bright = {
          black = "#585B70";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#A6ADC8";
        };
        dim = {
          black = "#45475A";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#BAC2DE";
        };
      };
    };
  };

  starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$character";
      directory = {
        style = "yellow";
      };
      character = {
        success_symbol = "[❯](yellow)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "green";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\) ";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
    };
  };

  atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      dialect = "uk";
      auto_sync = true;
      update_check = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
    };
  };

  tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    prefix = "C-space";
    escapeTime = 10;
    historyLimit = 50000;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      catppuccin
      sensible
      yank
      prefix-highlight
    ];
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -sg escape-time 10
      set -g focus-events on
      set-option -g status "on"
      #set-option -g status-justify 'left'
      set-window-option -g window-status-separator ""
      set -g status-bg default
      set -g status-style bg=default
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
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-l select-pane -R

      # Smart pane switching with awareness of Vim splits.
      # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
    '';
  };

  gitui = {
    enable = true;
    keyConfig = ''
      (
          open_help: Some(( code: F(1), modifiers: "")),

          move_left: Some(( code: Char('h'), modifiers: "")),
          move_right: Some(( code: Char('l'), modifiers: "")),
          move_up: Some(( code: Char('k'), modifiers: "")),
          move_down: Some(( code: Char('j'), modifiers: "")),

          popup_up: Some(( code: Char('p'), modifiers: "CONTROL")),
          popup_down: Some(( code: Char('n'), modifiers: "CONTROL")),
          page_up: Some(( code: Char('b'), modifiers: "CONTROL")),
          page_down: Some(( code: Char('f'), modifiers: "CONTROL")),
          home: Some(( code: Char('g'), modifiers: "")),
          end: Some(( code: Char('G'), modifiers: "SHIFT")),
          shift_up: Some(( code: Char('K'), modifiers: "SHIFT")),
          shift_down: Some(( code: Char('J'), modifiers: "SHIFT")),

          edit_file: Some(( code: Char('I'), modifiers: "SHIFT")),

          status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),

          diff_reset_lines: Some(( code: Char('u'), modifiers: "")),
          diff_stage_lines: Some(( code: Char('s'), modifiers: "")),

          stashing_save: Some(( code: Char('w'), modifiers: "")),
          stashing_toggle_index: Some(( code: Char('m'), modifiers: "")),

          stash_open: Some(( code: Char('l'), modifiers: "")),

          abort_merge: Some(( code: Char('M'), modifiers: "SHIFT")),
      )
    '';
    theme = ''
      (
          selected_tab: Some(Reset),
          command_fg: Some(Rgb(205, 214, 244)),
          selection_bg: Some(Rgb(88, 91, 112)),
          selection_fg: Some(Rgb(205, 214, 244)),
          cmdbar_bg: Some(Rgb(24, 24, 37)),
          cmdbar_extra_lines_bg: Some(Rgb(24, 24, 37)),
          disabled_fg: Some(Rgb(127, 132, 156)),
          diff_line_add: Some(Rgb(166, 227, 161)),
          diff_line_delete: Some(Rgb(243, 139, 168)),
          diff_file_added: Some(Rgb(249, 226, 175)),
          diff_file_removed: Some(Rgb(235, 160, 172)),
          diff_file_moved: Some(Rgb(203, 166, 247)),
          diff_file_modified: Some(Rgb(250, 179, 135)),
          commit_hash: Some(Rgb(180, 190, 254)),
          commit_time: Some(Rgb(186, 194, 222)),
          commit_author: Some(Rgb(116, 199, 236)),
          danger_fg: Some(Rgb(243, 139, 168)),
          push_gauge_bg: Some(Rgb(137, 180, 250)),
          push_gauge_fg: Some(Rgb(30, 30, 46)),
          tag_fg: Some(Rgb(245, 224, 220)),
          branch_fg: Some(Rgb(148, 226, 213))
      )
    '';
  };

  bat = {
    enable = true;
    config = {
      theme = "catppuccin";
    };
    themes = {
      catppuccin = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "Catppuccin-mocha.tmTheme";
      };
    };
  };
}
