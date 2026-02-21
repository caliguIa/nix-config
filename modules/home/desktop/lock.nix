{
    flake.modules.homeManager.desktop = {
        config,
        pkgs,
        ...
    }: {
        programs.hyprlock = {
            enable = true;
            settings = let
                style = {
                    font = "${config.stylix.fonts.sansSerif.name} Medium";
                    text = "rgba(d9e2ffFF)";
                    input = {
                        text = "rgba(d9e2ffFF)";
                        bg = "rgba(00194411)";
                        border = "rgba(8f909955)";
                    };
                };
            in {
                auth.fingerprint.enabled = true;
                background = [
                    {
                        monitor = "";
                        color = "rgba(181818FF)";
                    }
                ];
                input-field = [
                    {
                        monitor = "";
                        size = "250, 50";
                        outline_thickness = 2;
                        dots_size = 0.1;
                        dots_spacing = 0.3;
                        fade_on_empty = true;
                        position = "0, 20";
                        halign = "center";
                        valign = "center";
                        outer_color = style.input.border;
                        inner_color = style.input.bg;
                        font_color = style.input.text;
                    }
                ];
                label = [
                    {
                        monitor = "";
                        text = "$LAYOUT";
                        color = style.text;
                        font_size = 14;
                        font_family = style.font;
                        position = "-30, 30";
                        halign = "right";
                        valign = "bottom";
                    }
                    {
                        # Caps Lock Warning
                        monitor = "";
                        text = "cmd[update:250] ${pkgs.writeShellScriptBin "check-capslock" ''
                            MAIN_KB_CAPS=$(hyprctl devices | grep -B 6 "main: yes" | grep "capsLock" | head -1 | awk '{print $2}')
                            if [ "$MAIN_KB_CAPS" = "yes" ]; then
                                echo "Caps Lock active"
                            else
                                echo ""
                            fi
                        ''}/bin/check-capslock";
                        color = style.text;
                        font_size = 13;
                        font_family = style.font;
                        position = "0, -25";
                        halign = "center";
                        valign = "center";
                    }
                    {
                        # Clock
                        monitor = "";
                        text = "$TIME";
                        color = style.text;
                        font_size = 65;
                        font_family = style.font;
                        position = "0, 300";
                        halign = "center";
                        valign = "center";
                    }
                    {
                        # Date
                        monitor = "";
                        text = "cmd[update:5000] date +'%A, %B %d'";
                        color = style.text;
                        font_size = 18;
                        font_family = style.font;
                        position = "0, 240";
                        halign = "center";
                        valign = "center";
                    }
                    {
                        # User
                        monitor = "";
                        text = "$USER";
                        color = style.text;
                        outline_thickness = 2;
                        dots_size = 0.2;
                        dots_spacing = 0.2;
                        dots_center = true;
                        font_size = 20;
                        font_family = style.font;
                        position = "0, 50";
                        halign = "center";
                        valign = "bottom";
                    }
                    {
                        # Status
                        monitor = "";
                        text = "cmd[update:5000] ${pkgs.writeShellScriptBin "battery-status" ''
                            enable_battery=false
                            battery_charging=false

                            for battery in /sys/class/power_supply/*BAT*; do
                              if [[ -f "$battery/uevent" ]]; then
                                enable_battery=true
                                if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
                                  battery_charging=true
                                fi
                                break
                              fi
                            done

                            if [[ $enable_battery == true ]]; then
                              if [[ $battery_charging == true ]]; then
                                echo -n "󰂅 "
                              fi
                              if [[ $battery_charging == false ]]; then
                                echo -n "󰁹 "
                              fi
                              echo -n "$(cat /sys/class/power_supply/*/capacity | head -1)"%
                              if [[ $battery_charging == false ]]; then
                                echo -n " remaining"
                              fi
                            fi

                            echo ""
                        ''}/bin/battery-status";
                        color = style.text;
                        font_size = 14;
                        font_family = style.font;
                        position = "30, -30";
                        halign = "left";
                        valign = "top";
                    }
                ];
            };
        };
    };
}
