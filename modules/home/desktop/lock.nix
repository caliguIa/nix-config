{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        programs.swaylock = {
            enable = false;
            package = pkgs.swaylock-effects;
            settings = {
                screenshots = true;
                clock = true;
                indicator = true;
                effect-blur = "7x5";
                grace = 2;
                fade-in = 0.2;
            };
        };
    };
}
