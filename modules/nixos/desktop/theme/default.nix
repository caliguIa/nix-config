{inputs, ...}: {
    flake.modules.nixos.desktop = {pkgs, ...}: {
        imports = [inputs.stylix.nixosModules.stylix];
        stylix = let
            themes = import ./_themes;
        in {
            enable = true;
            autoEnable = false;
            fonts = {
                monospace = {
                    name = "Berkeley Mono";
                    package = inputs.fonts.packages.${pkgs.stdenvNoCC.system}.berkeley-mono;
                };
                serif = {
                    name = "DM Sans";
                    package = pkgs.dm-sans;
                };
                sansSerif = {
                    name = "DM Sans";
                    package = pkgs.dm-sans;
                };
                sizes = {
                    applications = 14;
                    desktop = 14;
                    popups = 14;
                    terminal = 14;
                };
            };
            base16Scheme = themes.kanso.pearl;
        };
    };
}
