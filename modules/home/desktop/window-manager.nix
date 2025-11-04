{
    flake.modules.homeManager.desktop = {
        config,
        lib,
        pkgs,
        ...
    }: {
        stylix.targets.sway.enable = false;
        wayland.windowManager.sway = let
            workspace = {
                "1" = "1";
                "2" = "2";
                "3" = "3";
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
            wrapperFeatures = {gtk = true;};
            config = {
                modifier = "Mod4";
                terminal = "ghostty";
                menu = "kickoff";
                left = "h";
                down = "j";
                up = "k";
                right = "l";
                defaultWorkspace = "workspace ${workspace."1"}";
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
                floating.criteria = [
                    {app_id = ".blueman-manager-wrapped";}
                    {app_id = "nm-openconnect-auth-dialog";}
                    {app_id = "nm-connection-editor";}
                    {app_id = "pavucontrol";}
                    {app_id = "flameshot";}
                    {
                        app_id = "thunderbird";
                        title = "Edit Event*";
                    }
                    {app_id = "xdg-desktop-portal-gtk";} # file picker
                    {title = "(Sharing Indicator)";}
                ];
                bars = [{command = lib.getExe config.programs.waybar.package;}];
                window = {
                    titlebar = lib.mkForce false;
                    border = lib.mkForce 0;
                    hideEdgeBorders = lib.mkForce "smart";
                    commands = [
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
                    ];
                };
                gaps.smartGaps = true;
                focus.newWindow = "focus";
                keybindings = let
                    mod = config.wayland.windowManager.sway.config.modifier;
                in {
                    "${mod}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
                    "${mod}+q" = "kill";
                    "${mod}+Space" = "exec ${config.wayland.windowManager.sway.config.menu}";
                    "${mod}+ctrl+c" = "reload";
                    "${mod}+ctrl+e" = "exec wlogout";
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
                    "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise --max-volume 120";
                    "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
                    "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
                    "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
                    "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";
                    "XF86AudioPlay" = "exec swayosd-client --playerctl play-pause";
                    "XF86AudioPrev" = "exec playerctl previous";
                    "XF86AudioNext" = "exec playerctl next";
                    "ctrl+shift+3" = "exec ${pkgs.writeShellScript "screenshot-focused" ''
                        filename="${config.home.homeDirectory}/Pictures/screenshots/$(date +%s_screenshot.png)"
                        ${pkgs.grim}/bin/grim -g \
                          "$(${pkgs.sway}/bin/swaymsg -t get_tree \
                          | ${pkgs.jq}/bin/jq -j '..
                          | select(.type?)
                          | select(.focused).rect
                          | "\(.x),\(.y) \(.width)x\(.height)"')" \
                          "$filename"
                        ${pkgs.libnotify}/bin/notify-send "Screenshot Taken" "$(basename "$filename")"
                    ''}";
                    "ctrl+shift+4" = "exec ${pkgs.writeShellScript "screenshot-area" ''
                        filename="${config.home.homeDirectory}/Pictures/screenshots/$(date +%s_screenshot.png)"
                        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$filename"
                        ${pkgs.libnotify}/bin/notify-send "Screenshot Taken" "$(basename "$filename")"
                    ''}";
                };
                startup = [
                    {command = "mako";}
                    {command = "swayosd-server";}
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
                # assigns = {
                #     "1: web" = [{class = "^Firefox$";}];
                # };
            };
        };
    };
}
