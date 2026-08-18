{
    flake.modules.nixos.desktop = { pkgs, ... }: {
        services.desktopManager.gnome.enable = true;

        programs.dconf.profiles.user.databases = [
            {
                settings."org/gnome/shell" = {
                    disable-user-extensions = false;
                    enabled-extensions = [
                        "clipboard-indicator@tudmotu.com"
                        "appindicatorsupport@rgcjonas.gmail.com"
                        "just-perfection-desktop@just-perfection"
                        "gsconnect@andyholmes.github.io"
                        "arcmenu@arcmenu.com"
                    ];
                };
                settings."org/gnome/desktop/interface" = {
                    color-scheme = "prefer-dark";
                    # gtk-theme = "YourTheme";
                    # icon-theme = "YourIcons";
                    # cursor-theme = "YourCursor";
                };
            }
        ];

        services.gnome = {
            games.enable = false;
            core-developer-tools.enable = false;
            gnome-browser-connector.enable = false;

            gnome-remote-desktop.enable = false;
            gnome-user-share.enable = false;
            rygel.enable = false;
            gnome-initial-setup.enable = false;
        };
        services.dleyna.enable = false;

        environment.gnome.excludePackages = with pkgs; [
            epiphany
            decibels
            gnome-characters
            gnome-clocks
            gnome-contacts
            gnome-maps
            gnome-music
            gnome-tecla
            gnome-weather
            showtime
            gnome-connections
            simple-scan
            yelp
            geary
            gnome-tour
            gnome-user-docs
            gnome-color-manager
            orca
        ];

        environment.systemPackages = with pkgs; [
            gnomeExtensions.clipboard-indicator
            gnomeExtensions.appindicator
            gnomeExtensions.just-perfection
            gnomeExtensions.gsconnect
            gnomeExtensions.arc-menu
            gnomeExtensions.github-tray
        ];
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
        environment.pathsToLink = [
            "/share/xdg-desktop-portal"
            "/share/applications"
        ];
    };
}
