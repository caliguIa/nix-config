{
    inputs,
    self,
    ...
}: {
    flake.modules.darwin.desktop = {
        imports = [
            inputs.stylix.darwinModules.stylix
            self.modules.generic.system-desktop-theme
        ];
    };

    flake.modules.nixos.desktop = {
        imports = [
            inputs.stylix.nixosModules.stylix
            self.modules.generic.system-desktop-theme
        ];
    };

    flake.modules.generic.system-desktop-theme = {pkgs, ...}: {
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
