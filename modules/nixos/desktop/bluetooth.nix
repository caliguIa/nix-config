{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.blueman.enable = true;
        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
        environment.systemPackages = with pkgs; [
            overskride
        ];
    };
}
