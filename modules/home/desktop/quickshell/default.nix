{
    flake.modules.homeManager.desktop = {
        programs.quickshell = {
            enable = false;
            systemd.enable = true;
        };
    };
}
