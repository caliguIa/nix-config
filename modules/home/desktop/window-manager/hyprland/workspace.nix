{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.hyprland.settings.workspace = [
            "1, monitor:eDP-1, persistent:true, default:true"
            "2, monitor:eDP-1, persistent:true"
            "3, monitor:eDP-1, persistent:true"
            "4, monitor:eDP-1, persistent:true"
            "special:special, gapsout:30"
        ];
    };
}
