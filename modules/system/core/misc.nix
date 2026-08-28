{
    flake.modules.nixos.core = {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        time.timeZone = "Europe/London";
        i18n.defaultLocale = "en_GB.UTF-8";
        # KDE reads per-category LC_* vars; set them explicitly so date, time,
        # numbers, currency, units etc. use British formats regardless of the
        # per-user Plasma regional state. Also ensures the en_GB locale is
        # generated so it appears in System Settings > Region & Language.
        i18n.extraLocaleSettings = {
            LC_ADDRESS = "en_GB.UTF-8";
            LC_IDENTIFICATION = "en_GB.UTF-8";
            LC_MEASUREMENT = "en_GB.UTF-8";
            LC_MONETARY = "en_GB.UTF-8";
            LC_NAME = "en_GB.UTF-8";
            LC_NUMERIC = "en_GB.UTF-8";
            LC_PAPER = "en_GB.UTF-8";
            LC_TELEPHONE = "en_GB.UTF-8";
            LC_TIME = "en_GB.UTF-8";
        };
    };
}
