{
    flake.modules.hjem.core = {
        pkgs,
        lib,
        ...
    }: let
        home = "/home/caligula";
        yaml = (pkgs.formats.yaml {}).generate;
        ghBin = "${pkgs.gh}/bin/gh";

        # gh extensions, previously installed by home-manager's
        # `programs.gh.extensions`, symlinked into gh's data dir.
        ghExtensions = pkgs.runCommand "gh-extensions" {} ''
            mkdir -p $out
            ln -s ${pkgs.gh-dash}/bin $out/gh-dash
            ln -s ${pkgs.gh-enhance}/bin $out/gh-enhance
        '';
    in {
        packages = with pkgs; [
            git
            gh
            gh-dash
            delta
            lazygit
            diffnav
        ];

        xdg.data.files."gh/extensions".source = ghExtensions;

        xdg.config.files = {
            "git/config" = {
                generator = lib.generators.toGitINI;
                value = {
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
                # gh credential helper (was programs.gh.gitCredentialHelper)
                "credential \"https://github.com\"" = {
                    helper = ["" "${ghBin} auth git-credential"];
                };
                "credential \"https://gist.github.com\"" = {
                    helper = ["" "${ghBin} auth git-credential"];
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

            "gh/config.yml".source = yaml "gh-config.yml" {
                version = "1";
                git_protocol = "https";
                editor = "";
                aliases = {};
            };

            "gh-dash/config.yml".source = yaml "gh-dash-config.yml" {
                pager.diff = "diffnav";
                repoPaths = {
                    "caliguIa/*" = "${home}/dev/*";
                    "stormburststudios/oneupsales" = "${home}/ous/";
                };
                prSections = [
                    {
                        title = "All";
                        filters = "is:open";
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
                            command = "cd {{.RepoPath}} && ${pkgs.gitu}/bin/gitu\n";
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

            "diffnav/config.yml".source = yaml "diffnav-config.yml" {
                ui.hideHeader = true;
                ui.hideFooter = true;
                ui.showFileTree = true;
                ui.fileTreeWidth = 26;
                ui.searchTreeWidth = 50;
                ui.icons = "filetype";
                ui.colorFileNames = false;
                ui.showDiffStats = false;
                ui.sideBySide = true;
                ui.startFoldersOpenDepth = -1;
            };

            "lazygit/config.yml".source = yaml "lazygit-config.yml" {
                git.pagers = [
                    {useExternalDiffGitConfig = true;}
                ];
                gui = {
                    border = "single";
                    nerdFontsVersion = "3";
                    theme.selectedLineBgColor = ["default"];
                };
                keybinding.universal = {
                    quitWithoutChangingDirectory = ["q" "<ctrl+c>"];
                    quit = ["Q"];
                };
            };
        };
    };
}
