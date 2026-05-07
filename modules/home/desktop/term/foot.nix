{
    flake.modules.homeManager.desktop = {style, ...}: {
        programs.foot = {
            enable = true;
            server.enable = true;
            settings = {
                main = {
                    font = "${style.font.monospace.name}:size=${toString style.font.monospace.size}";
                    line-height = 23.1;
                };
                scrollback.lines = 10000;
            };
        };
    };
}
