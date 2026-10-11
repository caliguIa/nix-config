{
    flake.modules.nixos.core = {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        time.timeZone = "Europe/London";
        i18n.defaultLocale = "en_GB.UTF-8";
    };
}
