{
    flake.modules.nixos.system-desktop-bluetooth = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [overskride];
        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
    };
}
