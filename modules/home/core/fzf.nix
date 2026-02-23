{
    flake.modules.homeManager.core = {
        programs.fzf = {
            enable = true;
            enableFishIntegration = true;
        };
        stylix.targets.fzf.enable = true;
    };
}
