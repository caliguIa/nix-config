{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.desktopManager.gnome.enable = true;
        environment.systemPackages = with pkgs; [
            gnomeExtensions.clipboard-indicator
            gnomeExtensions.appindicator
            gnomeExtensions.just-perfection
            gnomeExtensions.gsconnect
            # Manually packaging the below until version updates in nixpkgs support gnome 50
            # https://github.com/NixOS/nixpkgs/pull/523506
            # gnomeExtensions.arc-menu
        ];
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
        environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
    };
}
