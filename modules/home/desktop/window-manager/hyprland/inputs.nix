{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.hyprland.settings.input = {
            kb_layout = "gb";
            repeat_delay = 250;
            repeat_rate = 50;
            follow_mouse = 1;
            touchpad = {
                natural_scroll = 1;
                tap-to-click = 0;
                clickfinger_behavior = "yes";
                scroll_factor = 0.7;
            };
        };
    };
}
