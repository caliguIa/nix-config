{
    flake.modules.hjem.host_tarr = {
        xdg.config.files."sway/config.d/tarr.conf".text = ''
            # Dell S2719DC: 74.968 Hz is offered but sway defaults to 59.95 Hz.
            output HDMI-A-1 mode 2560x1440@74.968Hz
        '';
    };
}
