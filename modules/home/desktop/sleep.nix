{
    flake.modules.homeManager.desktop = {
        services.swayidle = {
            enable = true;
            events = {
                before-sleep = "loginctl lock-session";
                lock = "pidof swaylock || swaylock";
            };
            timeouts = [
                {
                    timeout = 150;
                    command = "brightnessctl -s set 10";
                    resumeCommand = "brightnessctl -r";
                }
                {
                    timeout = 300;
                    command = "loginctl lock-session";
                }
                {
                    timeout = 600;
                    command = "swaymsg 'output * dpms off'";
                    resumeCommand = "swaymsg 'output * dpms on' && brightnessctl -r";
                }
                {
                    timeout = 900;
                    command = "systemctl suspend || loginctl suspend";
                }
            ];
        };
    };
}
