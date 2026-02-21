{inputs, ...}: {
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        services.hyprpolkitagent.enable = true;
        wayland.windowManager.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenvNoCC.hostPlatform.system}.hyprland;
            portalPackage = inputs.hyprland.packages.${pkgs.stdenvNoCC.hostPlatform.system}.xdg-desktop-portal-hyprland;
            systemd.variables = ["--all"];
            xwayland.enable = true;
        };
    };
}
