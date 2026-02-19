{inputs, ...}: {
    flake.modules.homeManager.desktop = {
        pkgs,
        config,
        lib,
        ...
    }: {
        stylix.targets.waybar.enable = false;
        home.packages = [inputs.nextmeeting.packages.${pkgs.stdenvNoCC.hostPlatform.system}.default];
        programs.waybar = {
            enable = true;
            systemd.enable = true;
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 10;
                    reload_style_on_change = true;
                    modules-left = ["hyprland/workspaces" "custom/agenda"];
                    modules-center = ["clock" "custom/github"];
                    modules-right = ["cpu" "memory" "pulseaudio" "bluetooth" "network" "battery" "custom/system"];
                    "hyprland/workspaces" = {
                        format = "{icon}";
                        persistent-only = true;
                        persistent-workspaces = {
                            "*" = [1 2 3 4];
                        };
                        format-icons = {
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
                        tooltip = false;
                        on-click = "${pkgs.gnome-calendar}/bin/gnome-calendar";
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
                    "custom/agenda" = let
                        nextmeeting = lib.getExe inputs.nextmeeting.packages.${pkgs.stdenvNoCC.hostPlatform.system}.default;
                    in {
                        format = "{}";
                        exec = pkgs.writeShellScript "nextmeeting-waybar" ''
                            set -euo pipefail

                            output=$(${nextmeeting} --waybar --format "{minutes_until} • {title}" 2>/dev/null || echo '{"text": "", "tooltip": "No meetings"}')

                            # Check if output is valid JSON
                            if ! echo "$output" | ${lib.getExe pkgs.jq} -e . >/dev/null 2>&1; then
                              echo '{"text": "", "tooltip": "No upcoming meetings"}'
                              exit 0
                            fi

                            mins=$(echo "$output" | ${lib.getExe pkgs.jq} -r '.text' | ${lib.getExe pkgs.gnugrep} -oP '^\d+' 2>/dev/null || echo "0")

                            if [ -z "$mins" ] || [ "$mins" = "0" ]; then
                              echo "$output"
                              exit 0
                            fi

                            if [ "$mins" -gt 59 ]; then
                              hours=$((mins / 60))
                              remaining=$((mins % 60))
                              time_str="''${hours}h ''${remaining}m"
                            else
                              time_str="''${mins}m"
                            fi

                            echo "$output" | ${lib.getExe pkgs.jq} -c --arg time "$time_str" '.text = $time + " until " + (.text | sub("^[0-9]+ • "; "")) | .tooltip = $time + " • " + (.tooltip | sub("^• [0-9]+ • "; "• "))'
                        '';
                        on-click = nextmeeting + " --open-meet-url";
                        interval = 59;
                        return-type = "json";
                        tooltip = true;
                    };
                };
            };
            style = pkgs.writeText "waybar.css" ''
                @define-color palette-dark-1 #14171d;
                @define-color palette-dark-2 #1f1f26;
                @define-color palette-dark-3 #393B44;
                @define-color palette-white #f2f1ef;
                @define-color palette-red #c4746e;
                window * {
                  font-family: "Berkeley Mono";
                  font-size: 20px;
                  border: none;
                  border-radius: 4px;
                  color: @palette-white;
                }
                button label {
                  all: unset;
                }
                window#waybar {
                  background: @palette-dark-2;
                  border-radius: 0px;
                }
                #memory,
                #cpu,
                #network,
                #battery,
                #clock,
                #bluetooth,
                #clock-date,
                #custom-system,
                #custom-agenda,
                #custom-github,
                #mode,
                #window,
                #pulseaudio,
                #workspaces button
                {
                  padding: 4px 8px;
                  margin: 4px;
                  background: @palette-dark-1;
                }
                #custom-system,
                #custom-github,
                #battery,
                #bluetooth {
                  font-size: 22px;
                }
                #pulseaudio {
                  min-width: 14px;
                }
                #mode {
                  color: @palette-red;
                }
                #workspaces button {
                  color: @palette-dark-3;
                  border-bottom: 3px solid @palette-dark-3;
                }
                #workspaces button.active {
                  color: @palette-dark-1;
                  border-bottom: 3px solid @palette-white;
                }
                #workspaces button.urgent {
                  border-bottom: 3px solid @palette-red;
                }
            '';
        };
    };
}
