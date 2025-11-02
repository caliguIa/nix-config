{
    flake.modules.homeManager.desktop = {
        stylix.targets.waybar = {
            enable = false;
            addCss = true;
            enableCenterBackColors = false;
            enableLeftBackColors = false;
            enableRightBackColors = false;
            font = "monospace";
        };
        programs.waybar = {
            enable = true;
            systemd.enable = true;
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 10;
                    reload_style_on_change = true;
                    modules-left = ["sway/workspaces" "sway/mode"];
                    modules-center = ["sway/window"];
                    modules-right = ["battery" "clock"];
                    "sway/workspaces" = {
                        disable-scroll = true;
                        all-outputs = true;
                    };
                    "sway/window" = {
                        max-length = 50;
                    };
                    battery = {
                        format = "{capacity}% {icon}";
                        format-icons = [" " " " " " " " " "];
                    };
                    clock = {
                        format = "{:%a %d. %b  %H:%M:%S}";
                    };
                };
            };
        };
    };
}
