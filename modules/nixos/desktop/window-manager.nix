{inputs, ...}: {
    flake.modules.nixos.desktop = {pkgs, ...}: {
        imports = [inputs.hyprland.nixosModules.default];

        programs.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenvNoCC.hostPlatform.system}.hyprland;
            portalPackage = inputs.hyprland.packages.${pkgs.stdenvNoCC.hostPlatform.system}.xdg-desktop-portal-hyprland;
        };
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };
}
