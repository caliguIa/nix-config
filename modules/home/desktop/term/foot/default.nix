{
    flake.modules.homeManager.desktop = {
        stylix.targets.foot.enable = false;
        programs.foot = {
            enable = true;
            server.enable = true;
            settings = {
                main.line-height = 23.1;
                scrollback.lines = 10000;
            };
        };
    };
}
