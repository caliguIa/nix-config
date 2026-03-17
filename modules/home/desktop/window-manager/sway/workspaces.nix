{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.sway.config.workspaceOutputAssign = [
            { workspace = "1"; output = "eDP-1"; }
            { workspace = "2"; output = "eDP-1"; }
            { workspace = "3"; output = "eDP-1"; }
            { workspace = "4"; output = "eDP-1"; }
        ];
    };
}
