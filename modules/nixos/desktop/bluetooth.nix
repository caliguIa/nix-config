{
    flake.modules.nixos.desktop = {
        services.blueman.enable = true;
        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
    };
}
