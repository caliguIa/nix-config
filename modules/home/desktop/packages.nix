{
    flake.modules.homeManager.desktop = {
        programs.fuzzel.enable = true;
        programs.swaylock.enable = true;
        services.mako.enable = true;
        services.wob.enable = true;
        services.swayidle.enable = true;
    };
}
