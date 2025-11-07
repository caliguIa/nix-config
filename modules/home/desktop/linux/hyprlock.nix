{
    flake.modules.homeManager.desktop-linux = {config, ...}: {
        programs.hyprlock = {
            enable = true;
            settings = let
                colours = config.lib.stylix.colors;
            in {
                general = {
                    hide-cursor = true;
                    ignore_empty_input = true;
                    immediate_render = true;
                    text_trim = true;
                    fractional_scaling = 2;
                    screencopy_mode = 0;
                    fail_timeout = 1000;
                };
                animations.enabled = false;
                background = [
                    {
                        monitor = "";
                        color = "rgb(${colours.base01})";
                    }
                ];
                input-field = [
                    {
                        monitor = "";
                        size = "350, 60";
                        outline_thickness = 2;
                        rounding = 8;
                        dots_size = 0.2;
                        dots_spacing = 0.2;
                        dots_center = true;
                        outer_color = "rgb(${colours.base02})";
                        inner_color = "rgb(${colours.base00})";
                        font_color = "rgb(${colours.base06})";
                        check_color = "rgb(${colours.base02})";
                        fail_color = "rgb(${colours.base08})";
                        fade_on_empty = false;
                        font_family = config.stylix.fonts.monospace.name;
                        placeholder_text = ''<i><span foreground="##${colours.base03}">Enter Password</span></i>'';
                        hide_input = false;
                        position = "0, 0";
                        halign = "center";
                        valign = "center";
                    }
                ];
                label = [
                    {
                        monitor = "";
                        text = ''cmd[update:100000] echo "$(date "+%a %e %b")"'';
                        color = "rgb(${colours.base07})";
                        font_size = 36;
                        font_family = "${config.stylix.fonts.monospace.name} Bold";
                        position = "0, -30";
                        valign = "top";
                        halign = "center";
                        shadow_passes = 3;
                        shadow_size = 3;
                    }
                    {
                        monitor = "";
                        text = "$TIME";
                        color = "rgb(${colours.base07})";
                        font_size = 100;
                        font_family = "${config.stylix.fonts.monospace.name} Bold";
                        position = "0, -100";
                        valign = "top";
                        halign = "center";
                        shadow_passes = 3;
                        shadow_size = 3;
                    }
                    {
                        monitor = "";
                        text = "$USER";
                        color = "rgb(${colours.base06})";
                        font_size = 18;
                        font_family = config.stylix.fonts.monospace.name;
                        position = "0, 60";
                        valign = "center";
                        halign = "center";
                        shadow_passes = 3;
                        shadow_size = 3;
                    }
                ];
            };
        };
    };
}
