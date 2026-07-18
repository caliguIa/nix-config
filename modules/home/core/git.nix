{
    flake.modules.hjem.core = {
        config,
        pkgs,
        lib,
        ...
    }: let
        inherit (lib.meta) getExe;

        home = config.directory;
        yaml = pkgs.formats.yaml {};

        # gh's extension dir expects each extension as a directory containing
        # its executable; symlink each package's bin/ into place.
        ghExtensions = pkgs.runCommand "gh-extensions" {} ''
            mkdir -p $out
            ln -s ${pkgs.gh-dash}/bin $out/gh-dash
            ln -s ${pkgs.gh-enhance}/bin $out/gh-enhance
        '';
    in {
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
                    aliases = {};
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
