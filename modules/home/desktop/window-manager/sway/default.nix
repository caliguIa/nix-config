{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.sway = {
            enable = true;
            xwayland = true;
            systemd.variables = ["--all"];
            wrapperFeatures.gtk = false;
            swaynag.enable = true;
        };
    };
}
