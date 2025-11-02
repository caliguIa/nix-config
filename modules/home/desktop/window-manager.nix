{
    flake.modules.homeManager.desktop = {
        config,
        lib,
        ...
    }: {
        stylix.targets.sway.enable = false;
        wayland.windowManager.sway = let
            workspace = {
                "1" = "";
                "2" = "";
                "3" = "";
                "4" = "4";
                "5" = "5";
                "6" = "6";
                "7" = "7";
                "8" = "8";
                "9" = "9";
                "10" = "10";
            };
        in {
            enable = true;
            package = null;
            xwayland = true;
            systemd.enable = true;
            wrapperFeatures = {gtk = true;};
            config = {
                modifier = "Mod4";
                floating.modifier = "Mod4";
                terminal = "ghostty";
                menu = "kickoff";
                left = "h";
                down = "j";
                up = "k";
                right = "l";
                defaultWorkspace = workspace."1";
                output = {
                    eDP-1 = {
                        resolution = "2560x1600";
                        position = "1280,0";
                        scale = "1.5";
                    };
                    "*" = {
                        background = "${config.home.homeDirectory}/Pictures/bg/horse.jpg fill";
                    };
                };
                window = {
                    titlebar = lib.mkForce false;
                    border = lib.mkForce 0;
                    hideEdgeBorders = lib.mkForce "smart";
                    commands = [
                        {
                            criteria = {
                                app_id = "firefox";
                                title = "About Mozilla Firefox";
                            };
                            command = "floating enable";
                        }
                        {
                            criteria = {
                                app_id = "firefox";
                            };
                            command = "move container to workspace ${workspace."2"}";
                        }
                        {
                            criteria = {
                                app_id = "FFPWA-01K902TKNCJT4KVWV1HP92CGZ9";
                            };
                            command = "move container to workspace ${workspace."3"}";
                        }
                        {
                            criteria = {
                                title = "Save File";
                            };
                            command = "floating enable, resize set width 600px height 800px";
                        }
                        {
                            criteria = {
                                title = "(Sharing Indicator)";
                            };
                            command = "inhibit_idle visible, floating enable";
                        }
                        {
                            criteria = {
                                class = "1Password";
                            };
                            command = "floating enable";
                        }
                    ];
                };
                gaps.smartGaps = true;
                focus.newWindow = "focus";
                keybindings = let
                    mod = config.wayland.windowManager.sway.config.modifier;
                in {
                    "${mod}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
                    "${mod}+Shift+q" = "kill";
                    "${mod}+Space" = "exec ${config.wayland.windowManager.sway.config.menu}";
                    "${mod}+Shift+c" = "reload";
                    "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
                    "${mod}+h" = "focus left";
                    "${mod}+j" = "focus down";
                    "${mod}+k" = "focus up";
                    "${mod}+l" = "focus right";
                    "${mod}+Left" = "focus left";
                    "${mod}+Down" = "focus down";
                    "${mod}+Up" = "focus up";
                    "${mod}+Right" = "focus right";
                    "${mod}+Shift+h" = "move left";
                    "${mod}+Shift+j" = "move down";
                    "${mod}+Shift+k" = "move up";
                    "${mod}+Shift+l" = "move right";
                    "${mod}+Shift+Left" = "move left";
                    "${mod}+Shift+Down" = "move down";
                    "${mod}+Shift+Up" = "move up";
                    "${mod}+Shift+Right" = "move right";
                    "${mod}+Tab" = "workspace back_and_forth";
                    "${mod}+a" = "workspace ${workspace."1"}";
                    "${mod}+s" = "workspace ${workspace."2"}";
                    "${mod}+d" = "workspace ${workspace."3"}";
                    "${mod}+f" = "workspace ${workspace."4"}";
                    "${mod}+1" = "workspace ${workspace."1"}";
                    "${mod}+2" = "workspace ${workspace."2"}";
                    "${mod}+3" = "workspace ${workspace."3"}";
                    "${mod}+4" = "workspace ${workspace."4"}";
                    "${mod}+5" = "workspace ${workspace."5"}";
                    "${mod}+6" = "workspace ${workspace."6"}";
                    "${mod}+7" = "workspace ${workspace."7"}";
                    "${mod}+8" = "workspace ${workspace."8"}";
                    "${mod}+9" = "workspace ${workspace."9"}";
                    "${mod}+0" = "workspace ${workspace."10"}";
                    "${mod}+Shift+a" = "move container to workspace ${workspace."1"}";
                    "${mod}+Shift+s" = "move container to workspace ${workspace."2"}";
                    "${mod}+Shift+d" = "move container to workspace ${workspace."3"}";
                    "${mod}+Shift+f" = "move container to workspace ${workspace."4"}";
                    "${mod}+Shift+1" = "move container to workspace ${workspace."1"}";
                    "${mod}+Shift+2" = "move container to workspace ${workspace."2"}";
                    "${mod}+Shift+3" = "move container to workspace ${workspace."3"}";
                    "${mod}+Shift+4" = "move container to workspace ${workspace."4"}";
                    "${mod}+Shift+5" = "move container to workspace ${workspace."5"}";
                    "${mod}+Shift+6" = "move container to workspace ${workspace."6"}";
                    "${mod}+Shift+7" = "move container to workspace ${workspace."7"}";
                    "${mod}+Shift+8" = "move container to workspace ${workspace."8"}";
                    "${mod}+Shift+9" = "move container to workspace ${workspace."9"}";
                    "${mod}+Shift+0" = "move container to workspace ${workspace."10"}";
                    "${mod}+b" = "splith";
                    "${mod}+v" = "splitv";
                    "${mod}+e" = "layout toggle split";
                    "${mod}+m" = "fullscreen";
                    "${mod}+Shift+space" = "floating toggle";
                    "${mod}+r" = "mode resize";
                    "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
                    "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
                    "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
                    "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
                    "XF86AudioPlay" = "exec playerctl play-pause";
                    "XF86AudioPause" = "exec playerctl play-pause";
                    "XF86AudioPrev" = "exec playerctl previous";
                    "XF86AudioNext" = "exec playerctl next";
                    "XF86AudioStop" = "exec playerctl stop";
                    "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
                    "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
                    "Print" = "exec grim";
                };
                startup = [
                    {command = "mako";}
                    {command = "wob";}
                    {command = "swayidle -w timeout 300 \"swaylock -f -c 000000\" timeout 301 \"swaymsg 'output * power off'\" resume \"swaymsg 'output * power on'\" before-sleep \"swaylock -f -c 000000\"";}
                ];
                modes = {
                    resize = {
                        "h" = "resize shrink width 10px";
                        "j" = "resize grow height 10px";
                        "k" = "resize shrink height 10px";
                        "l" = "resize grow width 10px";
                        "Left" = "resize shrink width 10px";
                        "Down" = "resize grow height 10px";
                        "Up" = "resize shrink height 10px";
                        "Right" = "resize grow width 10px";
                        "Return" = "mode default";
                        "Escape" = "mode default";
                    };
                };
                bindswitches = let
                    laptop = "eDP-1";
                in {
                    "lid:on" = {
                        reload = true;
                        locked = true;
                        action = "output ${laptop} disable";
                    };
                    "lid:off" = {
                        reload = true;
                        locked = true;
                        action = "output ${laptop} enable";
                    };
                };
                bars = [];
                # assigns = {
                #     "1: web" = [{class = "^Firefox$";}];
                # };
            };
        };
    };
}
