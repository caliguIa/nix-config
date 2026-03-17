{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.sway.config = {
            defaultWorkspace = "workspace 1";
            window = {
                border = 1;
                hideEdgeBorders = "both";
                titlebar = false;
            };
        };
    };
}
