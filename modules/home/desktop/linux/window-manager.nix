{inputs, ...}: {
    flake.modules.homeManager.desktop-linux-window-manager = {
        config,
        pkgs,
        ...
    }: {
        wayland.windowManager.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
            systemd.variables = ["--all"];
            xwayland.enable = true;
            settings = {
                "$mod" = "SUPER";
                "$terminal" = "kitty";
                "$menu" = "kickoff --from-path";
                monitor = "eDP-1, 2560x1600@165, 0x0, 1.00";
                input = {
                    kb_options = "caps:swapescape";
                    touchpad = {
                        natural_scroll = 1;
                        tap-to-click = 0;
                        clickfinger_behavior = "yes";
                    };
                };
                # startup = [ {command = "exec wl-paste --watch clipvault store";} ];
                bind = [
                    "$mod, Return, exec, $terminal"
                    "$mod, T, exec, $terminal"
                    "$mod, R, exec, $menu"
                    "$mod, Q, killactive,"
                    "$mod, M, fullscreen, 1"
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
                    # Screenshot focused window
                    "$mod SHIFT, 3, exec, ${pkgs.writeShellScript "screenshot-focused" ''
                        filename="${config.home.homeDirectory}/Pictures/screenshots/$(date +%s_screenshot.png)"
                        ${pkgs.grim}/bin/grim -g \
                          "$(${pkgs.hyprland}/bin/hyprctl activewindow -j \
                          | ${pkgs.jq}/bin/jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" \
                          "$filename"
                        ${pkgs.libnotify}/bin/notify-send "Screenshot Taken" "$(basename "$filename")"
                    ''}"
                    # Screenshot selected area
                    "$mod SHIFT, 4, exec, ${pkgs.writeShellScript "screenshot-area" ''
                        filename="${config.home.homeDirectory}/Pictures/screenshots/$(date +%s_screenshot.png)"
                        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$filename"
                        ${pkgs.libnotify}/bin/notify-send "Screenshot Taken" "$(basename "$filename")"
                    ''}"
                ];
                bindm = [
                    "$mod, mouse:272, movewindow"
                    "$mod ALT, mouse:272, resizewindow"
                ];
                bindl = [
                    ",XF86PowerOff, exec, wlogout"
                    ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
                    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                    ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
                    ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
                    ",XF86AudioNext, exec, playerctl next"
                    ",XF86AudioPause, exec, playerctl play-pause"
                    ",XF86AudioPlay, exec, playerctl play-pause"
                    ",XF86AudioPrev, exec, playerctl previous"
                ];
                workspace = [
                    "1, monitor:eDP-1, persistent:true, default:true"
                    "2, monitor:eDP-1, persistent:true"
                    "3, monitor:eDP-1, persistent:true"
                    "4, monitor:eDP-1, persistent:true"
                ];
            };
        };
    };
}
