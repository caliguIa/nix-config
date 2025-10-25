{
    flake.modules.homeManager.core = {
        stylix.targets.yazi.enable = true;
        programs.yazi = {
            enable = true;
            enableFishIntegration = true;
            settings = {};
            keymap = {};
        };
    };
}
