{
    flake.modules.homeManager.desktop-common-direnv = {
        programs.direnv = {
            enable = true;
            silent = true;
        };
    };
}
