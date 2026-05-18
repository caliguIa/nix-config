{
    flake.modules.nixos.desktop = {
        services.desktopManager.gnome.enable = true;
        # qt = {
        #     enable = true;
        #     platformTheme = "gnome";
        #     style = "adwaita-dark";
        # };
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
        environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
    };
}
