{inputs, ...}: {
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        stylix.targets.fuzzel.enable = true;
        stylix.targets.vicinae.enable = true;
        programs.fuzzel = {
            enable = true;
            settings = {
                main = {
                    terminal = "${pkgs.kitty}/bin/kitty";
                    layer = "overlay";
                    prompt = ">>  ";
                };
                border = {
                    radius = 17;
                    width = 1;
                };
                dmenu.exit-immediately-if-empty = "yes";
            };
        };
        programs.vicinae = {
            enable = true;
            systemd.enable = false;
            settings = {
                close_on_focus_loss = false;
                consider_preedit = false;
                pop_to_root_on_close = false;
                favicon_service = "twenty";
                search_files_in_root = true;
            };
            extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenvNoCC.hostPlatform.system}; [
                bluetooth
                nix
                power-profile
            ];
        };
    };
}
