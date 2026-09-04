{
    flake.modules.nixos.desktop = { pkgs, ... }: {
        services.desktopManager.plasma6.enable = true;
        programs.kdeconnect.enable = true;
        environment.plasma6.excludePackages = with pkgs.kdePackages; [
            elisa
            konsole
            plasma-browser-integration
            kate
        ];
        environment.systemPackages = with pkgs.kdePackages; [
            akonadi-calendar
            kdepim-addons
            filelight
            merkuro
        ];
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
        environment.pathsToLink = [
            "/share/xdg-desktop-portal"
            "/share/applications"
        ];
    };
}
