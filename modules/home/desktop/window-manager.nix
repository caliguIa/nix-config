{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.sway = {
            enable = true;
            package = null;
            xwayland = true;
            systemd.enable = true;
            config = {
                keybindings = let
                    mod = "Mod4";
                in {
                    "${mod}+Return" = "exec foot";
                    "${mod}+d" = "exec wmenu-run";
                };
                fonts = {names = ["Berkeley Mono"];};
                output = {
                    eDP-1 = {
                        resolution = "2560x1600";
                        position = "1280,0";
                        scale = "1.5";
                    };
                    "*" = {
                        background = "/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
                    };
                };
                startup = [
                    {command = "mako";}
                    {command = "wob";}
                    {command = "swayidle -w timeout 300 \"swaylock -f -c 000000\" timeout 301 \"swaymsg 'output * power off'\" resume \"swaymsg 'output * power on'\" before-sleep \"swaylock -f -c 000000\"";}
                ];
            };
        };
    };
}
