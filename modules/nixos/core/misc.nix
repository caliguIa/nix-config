{
    flake.modules.nixos.core = {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        time.timeZone = "Europe/London";
    };
}
