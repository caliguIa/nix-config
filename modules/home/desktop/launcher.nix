{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        programs.fuzzel = {
            enable = true;
            settings = {
                main = {
                    terminal = "${pkgs.ghostty}/bin/ghostty";
                    layer = "overlay";
                    prompt = "'run: '";
                    dpi-aware = "no";
                    horizontal-pad = 8;
                    minimal-lines = 1;
                };
                border = {
                    radius = 0;
                    width = 1;
                };
                dmenu.exit-immediately-if-empty = "yes";
            };
        };
    };
}
