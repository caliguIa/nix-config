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
        "fnm"
        "gh"
        "git"
        "ripgrep"
        "rust"
        "tmux"
      ];
    };
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };
    dotDir = ".config/zsh";
    shellAliases = {
      "~" = "cd ~";
      dl = "cd ~/Downloads";
      dt = "cd ~/Desktop";
      df = "cd ~/nix-config";
      nvcf = "cd ~/nix-config/modules/shared/config/neovim";
      cf = "cd ~/.config";
      dev = "cd ~/dev";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ls = "eza -la";
      cat = "bat";
      gaa = "git add --all";
      gst = "git status";
      gac = "git add .; git commit";
      gco = "git checkout";
      gs = "git switch";
      gfp = "git fetch && git pull";
      undocommit = "git reset --soft HEAD^";
      dc = "docker-compose";
      dcu = "docker-compose up";
      dcb = "docker-compose build";
      dps = "docker ps";
      ip = "curl ifconfig.io";
      localip = "ipconfig getifaddr en0";
      ous = "cd ~/oneupsales/platform/resources/client";
      ousp = "cd ~/oneupsales/platform";
      ousr = "cd ~/oneupsales";
      update = "softwareupdate -ia";
      updatel = "softwareupdate -l";
      t = "tmux attach || tmux new";
      tks = "tmux kill-server";
      ":q" = "exit";
      fuck = "echo 'Running: \e[32msudo \e[35m\e[4m\$(fc -ln -1)\e[0m' && sudo \$(fc -ln -1)";
      nixbs = "cd ~/nix-config; git add .; nix run .#build-switch";
      #gitui = "gitui -t mocha.ron";
    };

    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      nixmv() {
        sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
        sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
        sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
      }

    '';
  };

  neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = [ pkgs.php82Packages.composer ];
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
