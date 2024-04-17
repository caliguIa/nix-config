{ config, pkgs, lib, ... }:

let
  name = "Cal";
  email = "accounts@cal.rip";
in {
  zsh = {
    enable = true;
    autocd = false;
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins =
        [ "docker" "docker-compose" "fnm" "gh" "git" "ripgrep" "rust" "tmux" ];
    };
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    history = { path = "${config.xdg.dataHome}/zsh/zsh_history"; };
    dotDir = ".config/zsh";
    localVariables = { ZSH_TMUX_AUTOSTART = true; };
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
      ous = "cd ~/oneupsales/platform";
      ousr = "cd ~/oneupsales";
      update = "softwareupdate -ia";
      updatel = "softwareupdate -l";
      t = "tmux attach || tmux new";
      tks = "tmux kill-server";
      ":q" = "exit";
      fuck =
        "echo 'Running: e[32msudo e[35me[4m$(fc -ln -1)e[0m' && sudo $(fc -ln -1)";
      nixbs = "cd ~/nix-config; git add .; nix run .#build-switch";
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

  helix = {
    enable = true;
    extraPackages = with pkgs; [
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      taplo
      rust-analyzer
      marksman
    ];
    settings = {
      theme = "base16_transparent";

      editor = {
        line-number = "relative";
        completion-trigger-len = 1;
        bufferline = "multiple";
        color-modes = true;
        statusline = {
          left = [
            "mode"
            "spacer"
            "diagnostics"
            "version-control"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
            "spinner"
          ];
          right = [ "file-encoding" "file-type" "selections" "position" ];
        };
        cursor-shape.insert = "bar";
        whitespace.render.tab = "all";
        indent-guides = {
          render = true;
          character = "┊";
        };
      };
    };
    languages.language = let
      prettier = {
        command = lib.getExe pkgs.nodePackages.prettier;
        args = lib.cli.toGNUCommandLine { } { w = true; };
      };
      jsRoots = [
        "package.json"
        "package-lock.json"
        "yarn.lock"
        "deno.json"
        "deno.lock"
        "bun.lockb"
      ];
    in [
      {
        name = "javascript";
        roots = jsRoots;
        formatter = prettier;
        auto-format = true;
      }
      {
        name = "typescript";
        roots = jsRoots;
        formatter = prettier;
        auto-format = true;
      }
      {
        name = "markdown";
        formatter = prettier;
        auto-format = true;
      }
      {
        name = "nix";
        roots = [ "flake.nix" "flake.lock" ];
        auto-format = true;
        language-servers = [ "nixd" ];
      }
    ];
  };

  git = {
    enable = true;
    userName = name;
    userEmail = email;
    lfs = { enable = true; };
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
      cursor = { style = "Block"; };

      window = {
        opacity = 1.0;
        blur = false;
        decorations = "none";
        startup_mode = "Maximized";
        padding = {
          x = 0;
          y = 0;
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
      format =
        "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$character";
      directory = { style = "yellow"; };
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
        format =
          "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
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
        format = "([$state( $progress_current/$progress_total)]($style)) ";
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
      set-option -sa terminal-features ',alacritty:RGB'
      set-option -ga terminal-features ",alacritty:usstyle"
      set -sg escape-time 10
      set -g focus-events on
      set-option -g status "on"
      set-option -g status-justify 'left'
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
    config = { theme = "catppuccin"; };
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
