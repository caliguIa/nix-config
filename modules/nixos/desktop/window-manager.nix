{
    flake.modules.nixos.desktop = {
        programs.sway = {
            enable = true;
            wrapperFeatures.gtk = false;
        };
        services.desktopManager.plasma6.enable = true;
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
        environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
    };
}
