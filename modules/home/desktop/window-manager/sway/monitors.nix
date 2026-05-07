{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.sway.config.output = {
            "eDP-1" = {
                mode = "2560x1600@165Hz";
                pos = "0 0";
                scale = "1";
            };
            "DP-2" = {
                mode = "2560x1440@74.968Hz";
                pos = "0 -2560";
                scale = "1";
            };
        };
    };
}
