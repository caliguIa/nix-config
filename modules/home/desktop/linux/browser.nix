{
    flake.modules.homeManager.desktop-linux-browser = {config, ...}: {
        programs.firefox.enable = true;
        xdg.systemDirs.data = ["${config.xdg.dataHome}"];
    };
}
