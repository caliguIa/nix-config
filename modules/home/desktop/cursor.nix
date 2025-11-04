{
    flake.modules.homeManager.desktop = {
        pkgs,
        config,
        ...
    }: {
        gtk = {
            enable = true;
            colorScheme = "dark";
            cursorTheme = {
                name = "Vanilla-DMZ";
                package = pkgs.vanilla-dmz;
                size = 128;
            };
            font.name = config.stylix.fonts.monospace.name;
        };
        home.pointerCursor = {
            enable = true;
            size = 128;
            name = "Vanilla-DMZ";
            package = pkgs.vanilla-dmz;
        };
    };
}
