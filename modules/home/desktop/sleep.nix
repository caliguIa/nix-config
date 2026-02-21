{
    flake.modules.homeManager.desktop = {
        services.hypridle = {
            enable = true;
            settings = {
                general = {
                    lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
                    before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
                    after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
                    inhibit_sleep = 3;
                };
                listener = [
                    {
                        timeout = 150;
                        on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum.
                        on-resume = "brightnessctl -r"; # monitor backlight restore.
                    }
                    {
                        timeout = 300;
                        on-timeout = "loginctl lock-session";
                    }
                    {
                        timeout = 600;
                        on-timeout = "hyprctl dispatch dpms off";
                        on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
                    }
                    {
                        timeout = 900;
                        on-timeout = "systemctl suspend || loginctl suspend";
                    }
                ];
            };
        };
    };
}
