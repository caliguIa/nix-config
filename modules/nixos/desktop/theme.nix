{inputs, ...}: {
    flake.modules.darwin.desktop = {
        pkgs,
        lib,
        ...
    }: {
        imports = [inputs.stylix.darwinModules.stylix];
        stylix = {
            enable = true;
            autoEnable = false;
            homeManagerIntegration.autoImport = true;
            homeManagerIntegration.followSystem = true;
            base16Scheme = let
                theme = "kanagawa";
            in "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
            fonts = rec {
                sansSerif = {
                    package = inputs.fonts.packages.${pkgs.system}.berkeley-mono;
                    name = "Berkeley Mono";
                };
                serif = sansSerif;
                monospace = sansSerif;
                sizes = {
                    applications = 14;
                    desktop = 14;
                    popups = 14;
                    terminal = 14;
                };
            };
        };
    };
    flake.modules.nixos.desktop = {
        pkgs,
        lib,
        ...
    }: {
        imports = [inputs.stylix.nixosModules.stylix];
        stylix = {
            enable = true;
            autoEnable = false;
            base16Scheme = let
                theme = "kanagawa";
            in "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
            fonts = rec {
                sansSerif = {
                    package = inputs.fonts.packages.${pkgs.system}.berkeley-mono;
                    name = "Berkeley Mono";
                };
                serif = sansSerif;
                monospace = sansSerif;
                sizes = {
                    applications = 14;
                    desktop = 14;
                    popups = 14;
                    terminal = 14;
                };
            };
        };
    };
}
