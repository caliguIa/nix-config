{
    flake.modules.nixos.gui = {
        services.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            # module-x11-bell segfaults pipewire whenever sway's lazy Xwayland
            # exits, killing pipewire-pulse; Chromium/Electron apps (Slack)
            # never reconnect and lose every audio device until restarted.
            extraConfig.pipewire."99-no-x11-bell"."context.properties"."module.x11.bell" = false;
        };
    };
}
