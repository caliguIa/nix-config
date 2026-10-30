{
    flake.modules.hjem.dev =
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
            ghBin = getExe pkgs.gh;

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
            ];

            xdg.data.files."gh/extensions".source = ghExtensions;

            # Included from core's /etc/gitconfig (include.path); git ignores the
            # include when this file is absent, e.g. on hosts without dev.
            xdg.config.files."git/gh-credentials".text = ''
                [credential "https://github.com"]
                	helper =
                	helper = ${ghBin} auth git-credential
                [credential "https://gist.github.com"]
                	helper =
                	helper = ${ghBin} auth git-credential
            '';

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
                                    name = "lazygit";
                                    command = "cd {{.RepoPath}} && ${getExe pkgs.lazygit}\n";
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
            };
        };
}
