{
    flake.modules.homeManager.desktop-linux-mako = {config, ...}: {
        services.mako = {
            enable = true;
            settings = let
                colours = config.lib.stylix.colors;
            in {
                background-color = "#${colours.base00}";
                border-color = "#${colours.base01}";
                border-radius = 4;
                font = "${config.stylix.fonts.monospace.name} ${toString (config.stylix.fonts.sizes.popups)}";
                height = 100;
                default-timeout = 5000;
                ignore-timeout = false;
                layer = "top";
                margin = 10;
                markup = true;
                padding = 8;
                text-color = "#${colours.base07}";
                width = 500;
            };
        };
    };
}
