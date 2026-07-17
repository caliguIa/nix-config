{
    flake.modules.homeManager.core = {
        pkgs,
        config,
        ...
    }: {
        programs.gh.enable = true;
        programs.gh.extensions = with pkgs; [gh-dash gh-enhance];
        programs.gh-dash = {
            enable = true;
            settings = {
                pager.diff = "diffnav";
                repoPaths = {
                    "caliguIa/*" = "${config.home.homeDirectory}/dev/*";
                    "stormburststudios/oneupsales" = "${config.home.homeDirectory}/ous/";
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
                            command = ''
                                cd {{.RepoPath}} && ${pkgs.gitu}/bin/gitu
                            '';
                        }
                    ];
                    prs = [
                        {
                            key = "O";
                            name = "review";
                            command = ''
                                cd {{.RepoPath}} && nvim -c ":Guh {{.PrNumber}}"
                            '';
                        }
                        {
                            key = "T";
                            name = "actions";
                            command = ''
                                gh enhance -R {{.RepoName}} {{.PrNumber}}
                            '';
                        }
                    ];
                };
            };
        };
        xdg.configFile."diffnav/config.yml".source = pkgs.writers.writeYAML "config.yaml" {
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
        programs.delta.enable = true;
        home.packages = with pkgs; [diffnav];
        programs.git = {
            enable = true;
            signing.format = null;
            settings = {
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
                pager.diff = "diffnav";
                fetch.prune = true;
                gc.auto = 200;
                init.defaultBranch = "main";
                push = {
                    autoSetupRemote = true;
                    default = "current";
                };
                remote = {
                    pushDefault = "origin";
                };
                pull = {
                    default = "current";
                };
                interactive.singlekey = true;
                interactive.diffFilter = "diffnav";
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
                url = {
                    "git@github.com:" = {
                        insteadOf = [
                            "https://github.com/"
                            "gh:"
                        ];
                    };
                    "git@github.com:caliguIa/" = {
                        insteadOf = [
                            "https://github.com/caliguIa/"
                            "cal:"
                        ];
                    };
                };
            };
        };
        programs.lazygit = {
            enable = true;
            enableFishIntegration = true;
            settings = {
                git = {
                    pagers = [
                        {useExternalDiffGitConfig = true;}
                    ];
                };
                gui = {
                    border = "single";
                    nerdFontsVersion = "3";
                    theme = {
                        selectedLineBgColor = ["default"];
                    };
                };
                keybinding.universal = {
                    quitWithoutChangingDirectory = ["q" "<ctrl+c>"];
                    quit = ["Q"];
                };
            };
        };
    };
}
