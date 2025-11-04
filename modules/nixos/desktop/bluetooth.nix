{
    flake.modules.nixos.system-desktop-bluetooth = {pkgs, ...}: {
        services.blueman.enable = true;
        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
    };
}
