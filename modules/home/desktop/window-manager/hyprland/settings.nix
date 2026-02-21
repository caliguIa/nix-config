{
    flake.modules.homeManager.desktop = {config, ...}: {
        wayland.windowManager.hyprland.settings = {
            monitor = "eDP-1, 2560x1600@165, 0x0, 1.00";
            misc = {
                font_family = config.stylix.fonts.sansSerif.name;
                focus_on_activate = true;
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                vfr = 1;
                vrr = 1;
                mouse_move_enables_dpms = true;
                key_press_enables_dpms = true;
                animate_manual_resizes = false;
                animate_mouse_windowdragging = false;
                enable_swallow = false;
                swallow_regex = "(foot|kitty|allacritty|Alacritty)";
                on_focus_under_fullscreen = 2;
                allow_session_lock_restore = true;
                session_lock_xray = false;
                initial_workspace_tracking = 0;
            };
        };
    };
}
