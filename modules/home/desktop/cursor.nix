{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        home.pointerCursor = {
            enable = true;
            package = pkgs.whitesur-cursors;
            name = "WhiteSur-cursors";
            size = 20;
        };
    };
}
