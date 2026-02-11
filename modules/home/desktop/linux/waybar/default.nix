{
    flake.modules.homeManager.desktop-linux-waybar = {
        pkgs,
        config,
        ...
    }: {
        stylix.targets.waybar.enable = false;
        programs.waybar = {
            enable = true;
            style = builtins.readFile ./style.css;
            systemd.enable = true;
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 10;
                    reload_style_on_change = true;
                    modules-left = ["hyprland/workspaces"];
                    modules-center = ["clock" "custom/github"];
                    modules-right = ["cpu" "memory" "pulseaudio" "bluetooth" "network" "battery" "custom/system"];
                    "hyprland/workspaces" = {
                        format = "{icon}";
                        persistent-workspaces = {
                            "*" = {
                                "1" = [];
                                "2" = [];
                                "3" = [];
                                "4" = [];
                            };
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
                            "0" = "0";
                        };
                    };
                    cpu.format = "{usage}% ";
                    memory.format = "{used}GB ";
                    battery = {
                        format = "{icon}";
                        format-icons = {
                            default = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
                            charging = ["󰢟" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
                        };
                        tooltip = true;
                        tooltip-format = "{capacity}% {timeTo}";
                    };
                    bluetooth = {
                        format-on = "󰂯";
                        format-off = "󰂲";
                        format-disabled = "󰂲";
                        format-connected = "󰂱";
                        tooltip-format-connected = "{device_enumerate}";
                        tooltip-format-enumerate-connected = "{device_alias} {device_battery_percentage}%";
                        on-click = "${pkgs.blueman}/bin/blueman-manager";
                    };
                    clock = {
                        format = "{:%a %d %b  %H:%M:%S}";
                        interval = 1;
                    };
                    network = {
                        format-wifi = "{icon}";
                        format-disconnected = "󰖪";
                        format-ethernet = "";
                        format-icons = [""];
                        tooltip = true;
                        tooltip-format = "";
                        tooltip-format-wifi = "{essid} - {frequency}";
                        on-click = "${pkgs.iwgtk}/bin/iwgtk";
                    };
                    pulseaudio = {
                        on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
                        tooltip = false;
                        scroll-step = 5;
                        format = "{icon}";
                        format-muted = "";
                        format-icons = {
                            default = ["" "" "" "" "" "" "" "" "" ""];
                        };
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
