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
            size = 16;
        };
        gtk = {
            enable = true;
            colorScheme = "dark";
            theme = {
                package = pkgs.flat-remix-gtk;
                name = "Flat-Remix-GTK-Grey-Darkest";
            };
            iconTheme = {
                package = pkgs.adwaita-icon-theme;
                name = "Adwaita";
            };
            font = {
                name = config.stylix.fonts.monospace.name;
                size = 11;
            };
        };
    };
}
