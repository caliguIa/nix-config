{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        home.pointerCursor = {
            enable = true;
            gtk.enable = true;
            package = pkgs.whitesur-cursors;
            name = "WhiteSur-cursors";
            size = 20;
        };
        gtk = {
            enable = true;
            # colorScheme = "dark";
            iconTheme = {
                name = "Adwaita";
                package = pkgs.adwaita-icon-theme;
            };
        };
    };
}
