{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.sway.config.input = {
            "*" = {
                xkb_layout = "gb";
                repeat_delay = "250";
                repeat_rate = "50";
            };
            "type:touchpad" = {
                natural_scroll = "enabled";
                tap = "disabled";
                click_method = "clickfinger";
                scroll_factor = "0.7";
            };
        };
    };
}
