{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        services.swayidle = {
            enable = true;
            timeouts = [
                {
                    timeout = 300;
                    command = "${pkgs.hyprlock}/bin/hyprlock";
                }
                {
                    timeout = 301;
                    command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
                    resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
                }
                {
                    timeout = 90;
                    command = "${pkgs.systemd}/bin/systemctl suspend";
                }
            ];
            events = [
                {
                    event = "before-sleep";
                    command = "${pkgs.hyprlock}/bin/hyprlock";
                }
            ];
        };
    };
}
