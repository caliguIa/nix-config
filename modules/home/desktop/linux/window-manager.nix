{
    flake.modules.homeManager.desktop-linux-window-manager = {
        config,
        lib,
        pkgs,
        ...
    }: {
        stylix.targets.sway.enable = false;
        services.swayidle.enable = true;
        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;
            systemd.variables = ["--all"];
            settings = {
                "$mod" = "SUPER";
                "$terminal" = "kitty";
                "$menu" = "kickoff --from-path";
                monitor = "eDP-1, 2560x1600@165, 0x0, 1.60";
                input = {
                    kb_options = "caps:swapescape";
                    touchpad = {
                        natural_scroll = 1;
                        tap-to-click = 0;
                        clickfinger_behavior = "yes";
                    };
                };
                bind = [
                    "$mod, Return, exec, $terminal"
                    "$mod, T, exec, $terminal"
                    "$mod, R, exec, $menu"
                    "$mod, Q, killactive,"

                    "$mod, H, movefocus, l"
                    "$mod, J, movefocus, d"
                    "$mod, K, movefocus, u"
                    "$mod, L, movefocus, r"

                    "$mod, A, workspace, 1"
                    "$mod, S, workspace, 2"
                    "$mod, D, workspace, 3"
                    "$mod, F, workspace, 4"
                    "$mod SHIFT, A, movetoworkspace, 1"
                    "$mod SHIFT, S, movetoworkspace, 2"
                    "$mod SHIFT, D, movetoworkspace, 3"
                    "$mod SHIFT, F, movetoworkspace, 4"
                ];
                bindm = [
                    "$mod, mouse:272, movewindow"
                    "$mod, mouse:274, resizewindow"
                ];
                bindl = [
                    ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
                    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                    ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
                    ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
                    ", XF86AudioNext, exec, playerctl next"
                    ", XF86AudioPause, exec, playerctl play-pause"
                    ", XF86AudioPlay, exec, playerctl play-pause"
                    ", XF86AudioPrev, exec, playerctl previous"
                ];
                exec-once = [
                    "$terminal"
                    "waybar"
                ];
            };
        };
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
                menu = "kickoff-programs";
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
                    {app_id = "io.github.kaii_lb.Overskride";}
                    {app_id = "org.twosheds.iwgtk";}
                    {app_id = "pavucontrol";}
                    {app_id = "org.gnome.Nautilus";}
                    {
                        app_id = "thunderbird";
                        title = "Edit Event*";
                    }
                    {app_id = "xdg-desktop-portal-gtk";}
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
                startup = [
                    {command = "exec wl-paste --watch clipvault store";}
                ];
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
                    "${mod}+c" = "exec kickoff-clipvault";
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
                    "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
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
