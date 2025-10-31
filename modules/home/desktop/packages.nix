{
    flake.modules.homeManager.desktop = {
        programs.firefox.enable = true;
        programs.waybar.enable = true;
        programs.fuzzel.enable = true;
        programs.swaylock.enable = true;
        services.mako.enable = true;
        services.wob.enable = true;
        services.swayidle.enable = true;
    };
}
