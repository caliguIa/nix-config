{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        stylix.targets.swaylock.enable = true;
        programs.swaylock = {
            enable = true;
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
