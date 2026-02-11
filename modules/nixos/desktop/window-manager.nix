{inputs, ...}: {
    flake.modules.nixos.system-desktop-wm = {pkgs, ...}: {
        imports = [inputs.hyprland.nixosModules.default];

        programs.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        };
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };
}
