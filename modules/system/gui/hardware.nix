{
    flake.modules.nixos.gui =
        { lib, ... }:
        {
            options.boot.initrd.luks.devices = lib.mkOption {
                type = lib.types.attrsOf (
                    lib.types.submodule {
                        config.allowDiscards = lib.mkDefault true;
                    }
                );
            };

            config = {
                services.fstrim.enable = lib.mkDefault true;
                hardware.graphics.enable = true;

                # Logitech C930e fails to resume from USB autosuspend; the kernel
                # resets it on every wake, blanking the video feed mid-call.
                services.udev.extraRules = ''
                    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="0843", TEST=="power/control", ATTR{power/control}="on"
                '';
            };
        };
}
