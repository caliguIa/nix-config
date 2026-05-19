{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.desktopManager.gnome.enable = true;
        environment.systemPackages = with pkgs; [
            gnomeExtensions.gsconnect
            gnomeExtensions.clipboard-indicator
            gnomeExtensions.appindicator
            gnomeExtensions.just-perfection
            gnomeExtensions.arc-menu
        ];
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
        environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
    };
}
