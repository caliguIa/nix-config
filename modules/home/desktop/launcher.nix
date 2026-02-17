{inputs, ...}: {
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        programs.vicinae = {
            enable = true;
            systemd = {
                enable = true;
                autoStart = true;
            };
            settings = {
                close_on_focus_loss = true;
                consider_preedit = true;
                pop_to_root_on_close = true;
                favicon_service = "twenty";
                search_files_in_root = true;
                font = {
                    normal = {
                        size = 18;
                    };
                };
                theme = {
                    light = {
                        name = "vicinae-light";
                        icon_theme = "default";
                    };
                    dark = {
                        name = "vicinae-dark";
                        icon_theme = "default";
                    };
                };
                launcher_window = {
                    opacity = 0.95;
                };
            };
            extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenvNoCC.hostPlatform.system}; [
                bluetooth
                nix
                power-profile
            ];
        };
    };
}
