{
    flake.modules.hjem.host_karla = {
        xdg.config.files."sway/config.d/karla.conf".text = ''
            output eDP-1 scale 1.0 mode 2560x1600@165Hz adaptive_sync on

            # Named so DMS never adjusts the keyboard backlight or an external monitor.
            bindsym --locked XF86MonBrightnessUp exec dms ipc call brightness increment 5 "backlight:amdgpu_bl1"
            bindsym --locked XF86MonBrightnessDown exec dms ipc call brightness decrement 5 "backlight:amdgpu_bl1"
        '';
    };
}
