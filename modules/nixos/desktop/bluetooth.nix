{
    flake.modules.nixos.system-desktop-bluetooth = {
        services.blueman.enable = true;
        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
    };
}
