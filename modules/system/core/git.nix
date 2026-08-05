{
  flake.modules.nixos.core =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib.meta) getExe;
      ghBin = getExe pkgs.gh;
    in
    {
      programs.git = {
        enable = true;
        config = {
          user = {
            name = "Cal";
            email = "acc@calrichards.io";
          };
          advice = {
            addEmptyPathspec = false;
            pushNonFastForward = false;
            statusHints = false;
          };
          core = {
            editor = "nvim";
            compression = 9;
            whitespace = "error";
            preloadindex = true;
            symlinks = true;
            autocrlf = "input";
          };
          "credential \"https://github.com\"" = {
            helper = [
              ""
              "${ghBin} auth git-credential"
            ];
          };
          "credential \"https://gist.github.com\"" = {
            helper = [
              ""
              "${ghBin} auth git-credential"
            ];
          };
          pager.diff = "diffnav";
          fetch.prune = true;
          gc.auto = 200;
          init.defaultBranch = "main";
          push = {
            autoSetupRemote = true;
            default = "current";
          };
          remote.pushDefault = "origin";
          pull.default = "current";
          interactive = {
            singlekey = true;
            diffFilter = "diffnav";
          };
          status = {
            branch = true;
            showStash = true;
            showUntrackedFiles = "all";
          };
          delta = {
            "syntax-theme" = "kanso-zen";
            "dark" = "true";
            "tabs" = "2";
            "file-style" = "omit";
            "file-decoration-style" = "none";
            "line-numbers-left-format" = "{nm:>4} ";
            "line-numbers-right-format" = "│ {np:>4} ";
            "line-numbers-left-style" = "white dim";
            "line-numbers-right-style" = "#1f2335 dim";
            "line-numbers-zero-style" = "white dim";
            "line-numbers-plus-style" = "white dim ";
            "line-numbers-minus-style" = "white dim";
            "wrap-left-symbol" = " ";
            "wrap-right-symbol" = " ";
            "wrap-right-prefix-symbol" = " ";
            "plus-style" = "syntax #0e250e";
            "plus-emph-style" = "syntax #103610";
            "minus-style" = "syntax #402a26";
            "minus-emph-style" = "syntax #45221c";
            "hunk-label" = "  󰡏 ";
            "hunk-header-line-number-style" = "#10233A";
            "hunk-header-style" = "#868E99";
            "hunk-header-file-style" = "#868E99 dim";
            "hunk-header-decoration-style" = "#163050 ol ul";
          };
          "url \"git@github.com:\"".insteadOf = [
            "https://github.com/"
            "gh:"
          ];
          "url \"git@github.com:caliguIa/\"".insteadOf = [
            "https://github.com/caliguIa/"
            "cal:"
          ];
        };
      };

      programs.lazygit = {
        enable = true;
        settings = {
          git.pagers = [
            { useExternalDiffGitConfig = true; }
          ];
          gui = {
            border = "single";
            nerdFontsVersion = "3";
            theme.selectedLineBgColor = [ "default" ];
          };
          keybinding.universal = {
            quitWithoutChangingDirectory = [
              "q"
              "<ctrl+c>"
            ];
            quit = [ "Q" ];
          };
        };
      };
    };

  flake.modules.hjem.core =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib.meta) getExe;

      home = config.directory;
      yaml = pkgs.formats.yaml { };
      toml = pkgs.formats.toml { };

      # gh's extension dir expects each extension as a directory containing
      # its executable; symlink each package's bin/ into place.
      ghExtensions = pkgs.runCommand "gh-extensions" { } ''
        mkdir -p $out
        ln -s ${pkgs.gh-dash}/bin $out/gh-dash
        ln -s ${pkgs.gh-enhance}/bin $out/gh-enhance
      '';
    in
    {
      packages = with pkgs; [
        gh
        gh-dash
        delta
        diffnav
      ];

      xdg.data.files."gh/extensions".source = ghExtensions;

      xdg.config.files = {
        "gh/config.yml" = {
          generator = yaml.generate "gh-config.yml";
          value = {
            version = "1";
            git_protocol = "https";
            editor = "";
            aliases = { };
          };
        };

        "gh-dash/config.yml" = {
          generator = yaml.generate "gh-dash-config.yml";
          value = {
            pager.diff = "diffnav";
            repoPaths = {
              "caliguIa/*" = "${home}/dev/*";
              "stormburststudios/oneupsales" = "${home}/ous/";
            };
            prSections = [
              {
                title = "All";
                filters = "is:open draft:false sort:updated-desc";
              }
              {
                title = "Author";
                filters = "is:open author:@me";
              }
              {
                title = "Requested";
                filters = "is:open review-requested:@me";
              }
              {
                title = "Involved";
                filters = "is:open involves:@me -author:@me";
              }
            ];
            keybindings = {
              universal = [
                {
                  key = "g";
                  name = "gitu";
                  command = "cd {{.RepoPath}} && ${getExe pkgs.gitu}\n";
                }
              ];
              prs = [
                {
                  key = "O";
                  name = "review";
                  command = "cd {{.RepoPath}} && nvim -c \":Guh {{.PrNumber}}\"\n";
                }
                {
                  key = "T";
                  name = "actions";
                  command = "gh enhance -R {{.RepoName}} {{.PrNumber}}\n";
                }
              ];
            };
          };
        };

        "gitu/config.toml" = {
          generator = toml.generate "gitu-config.toml";
          value = {
            bindings = {
              root.discard = [ "x" ];
              root.pull_menu = [ "p" ];
            };
            style = {
              separator.mods = "DIM";
              info_msg = {
                fg = "green";
                mods = "BOLD";
              };
              error_msg = {
                fg = "red";
                mods = "BOLD";
              };
              command = {
                fg = "blue";
                mods = "BOLD";
              };
              menu = {
                heading = {
                  fg = "yellow";
                  mods = "BOLD";
                };
                key = {
                  fg = "magenta";
                  mods = "BOLD";
                };
                active_arg = {
                  fg = "light red";
                  mods = "BOLD";
                };
                inactive_arg = { };
              };
              prompt = {
                fg = "cyan";
                mods = "BOLD";
              };
              section_header = {
                fg = "yellow";
                mods = "BOLD";
              };
              file_header = {
                fg = "magenta";
                mods = "BOLD";
              };
              hunk_header = {
                fg = "blue";
                bg = "#2a2e36";
              };
              diff_highlight = {
                tag_old = {
                  fg = "red";
                  mods = "";
                };
                tag_new = {
                  fg = "green";
                  mods = "";
                };
                changed_old = {
                  bg = "#43242b";
                  mods = "BOLD";
                };
                changed_new = {
                  bg = "#2b3328";
                  mods = "BOLD";
                };
              };
              syntax_highlight = {
                enabled = true;
                attribute.fg = "yellow";
                comment.fg = "gray";
                constant_builtin = { };
                constant = { };
                constructor = { };
                embedded = { };
                function_builtin.fg = "cyan";
                function.fg = "blue";
                keyword.fg = "magenta";
                number = { };
                module.fg = "cyan";
                property = { };
                operator = { };
                punctuation_bracket = { };
                punctuation_delimiter = { };
                string_special.fg = "yellow";
                string.fg = "yellow";
                tag = { };
                type.fg = "yellow";
                type_builtin.fg = "yellow";
                variable_builtin = { };
                variable_parameter = { };
              };
              picker = {
                prompt.fg = "cyan";
                info.mods = "DIM";
                selection_line.mods = "BOLD";
                matched = {
                  fg = "yellow";
                  mods = "BOLD";
                };
              };
              cursor = {
                symbol = "▌";
                fg = "yellow";
              };
              selection_bar = {
                symbol = "▌";
                fg = "yellow";
              };
              selection_line.bg = "#2a2e36";
              selection_area.bg = "#2a2e36";
              hash.fg = "yellow";
              branch = {
                fg = "green";
                mods = "BOLD";
              };
              remote.fg = "red";
              tag.fg = "yellow";
              blame = {
                line_num.mods = "DIM";
                code_line.mods = "DIM";
              };
            };
          };
        };

        "diffnav/config.yml" = {
          generator = yaml.generate "diffnav-config.yml";
          value.ui = {
            hideHeader = true;
            hideFooter = true;
            showFileTree = true;
            fileTreeWidth = 26;
            searchTreeWidth = 50;
            icons = "filetype";
            colorFileNames = false;
            showDiffStats = false;
            sideBySide = true;
            startFoldersOpenDepth = -1;
          };
        };
      };
    };
}
