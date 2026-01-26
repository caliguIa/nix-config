{
    flake.modules.homeManager.desktop-linux-waybar = {
        pkgs,
        config,
        ...
    }: {
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
            style = builtins.readFile ./style.css;
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 10;
                    reload_style_on_change = true;
                    modules-left = ["sway/workspaces" "sway/mode"];
                    modules-center = ["clock" "custom/github"];
                    modules-right = ["cpu" "memory" "bluetooth" "network" "battery" "custom/system"];
                    "sway/workspaces" = {
                        disable-scroll = true;
                        disable-scroll-wraparound = true;
                        all-outputs = true;
                        format = "{icon}";
                        persistent-workspaces = {
                            "1" = [];
                            "2" = [];
                            "3" = [];
                            "4" = [];
                        };
                        format-icons = {
                            default = "";
                            "1" = "";
                            "2" = "󰖟";
                            "3" = "";
                            "4" = "";
                            "5" = "5";
                            "6" = "6";
                            "7" = "7";
                            "8" = "8";
                            "9" = "9";
                            "10" = "10";
                        };
                    };
                    "sway/window" = {
                        max-length = 50;
                    };
                    cpu.format = "{usage}% ";
                    memory.format = "{used}GiB ";
                    battery = {
                        format = "{capacity}% <span font='14'>{icon}</span>";
                        format-charging = "{capacity}% ";
                        format-icons = ["" "" "" "" ""];
                        tooltip = false;
                    };
                    bluetooth = {
                        format-on = "󰂯";
                        format-off = "󰂲";
                        format-disabled = "󰂲";
                        format-connected = "󰂱";
                        tooltip-format-connected = "{device_enumerate}";
                        tooltip-format-enumerate-connected = "{device_alias} {device_battery_percentage}%";
                        on-click = "${pkgs.overskride}/bin/overskride";
                    };
                    clock = {
                        format = "{:%a %d %b  %H:%M:%S}";
                        interval = 1;
                    };
                    network = {
                        format-wifi = "{essid} {icon}";
                        format-disconnected = "󰖪";
                        format-ethernet = "";
                        format-icons = [""];
                        on-click = "${pkgs.iwgtk}/bin/iwgtk";
                        tooltip = false;
                    };
                    "custom/github" = {
                        format = "{}";
                        return-type = "json";
                        tooltip = false;
                        interval = 60;
                        exec = pkgs.writeShellScript "github-notifications" ''
                            token=$(cat ${config.home.homeDirectory}/.config/github/notifications.token)
                            count=$(${pkgs.curl}/bin/curl -u username:''${token} https://api.github.com/notifications 2>/dev/null | ${pkgs.jq}/bin/jq '. | length')

                            if [[ "$count" != "0" && "$count" != "" ]]; then
                                echo "{\"text\":\"<sup><span foreground=\\\"#c4746e\\\" size=\\\"xx-small\\\">●</span></sup>\",\"tooltip\":\"$count GitHub notifications\",\"class\":\"notifications\"}"
                            else
                                echo "{\"text\":\"\",\"tooltip\":\"No notifications\",\"class\":\"empty\"}"
                            fi
                        '';
                        on-click = "${pkgs.xdg-utils}/bin/xdg-open https://github.com/notifications";
                    };
                    "custom/system" = {
                        format = "";
                        interval = "once";
                        on-click = "wlogout";
                    };
                };
            };
        };
    };
}
