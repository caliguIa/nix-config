{
    flake.modules.homeManager.desktop-linux-cursor = {
        pkgs,
        config,
        ...
    }: {
        home.pointerCursor = {
            enable = true;
            gtk.enable = true;
            package = pkgs.whitesur-cursors;
            name = "WhiteSur-cursors";
            size = 20;
        };
        gtk = {
            enable = true;
            colorScheme = "dark";
            theme = {
                name = "Adwaita";
                package = pkgs.gnome-themes-extra;
            };
            iconTheme = {
                name = "Adwaita";
                package = pkgs.adwaita-icon-theme;
            };
            font = {
                name = config.stylix.fonts.monospace.name;
                size = 16;
            };
        };
    };
}
