{
    flake.modules.nixos.dev =
        {
            pkgs,
            lib,
            ...
        }:
        let
            inherit (pkgs) elio;
            bin = lib.getExe elio;

            shellFuncBody = ''
                switch "$argv[1]"
                    case shell '-*'
                        '${bin}' $argv
                        return $status
                end

                for arg in $argv
                    switch "$arg"
                        case --chooser-file '--chooser-file=*'
                            '${bin}' $argv
                            return $status
                    end
                end

                set -l tmp (mktemp -t "elio-cwd.XXXXXX")
                or return

                '${bin}' --cwd-file "$tmp" $argv
                set -l status_code $status

                if test -s "$tmp"
                    set -l cwd (string collect < "$tmp")
                    rm -f "$tmp"
                    if test -n "$cwd"; and test "$cwd" != "$PWD"; and test -d "$cwd"
                        cd "$cwd"; or return $status
                    end
                else
                    rm -f "$tmp"
                end

                return $status_code
            '';
        in
        {
            environment.systemPackages = [ elio ];

            programs.fish.interactiveShellInit = ''
                function elio
                    ${shellFuncBody}
                end

                function e
                    ${shellFuncBody}
                end
            '';
        };

    flake.modules.hjem.dev =
        { pkgs, ... }:
        let
            toml = pkgs.formats.toml { };
        in
        {
            xdg.config.files = {
                "elio/config.toml" = {
                    generator = toml.generate "elio-config.toml";
                    value = {
                        ui.show_hidden = true;
                        places = {
                            entries = [
                                "home"
                                "root"
                                "desktop"
                                {
                                    title = "dev";
                                    path = "~/dev";
                                    icon = "";
                                }
                                "documents"
                                "downloads"
                                "music"
                                {
                                    title = "ous";
                                    path = "~/ous";
                                    icon = "";
                                }
                                "pictures"
                                "videos"
                                "trash"
                            ];
                            show_devices = true;
                        };
                    };
                };
            };
        };
}
