{
    flake.modules.homeManager.core = {
        programs.fzf = {
            enable = true;
            enableBashIntegration = true;
        };
    };
}
