{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.hyprland.settings = {
            exec-once = [
                "vicinae server"
            ];
        };
    };
}
