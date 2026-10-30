{ lib, ... }:
{
    flake.modules.nixos.core = {
        # Workstations replace it with lanzaboote.
        boot.loader.systemd-boot.enable = lib.mkDefault true;
        boot.loader.efi.canTouchEfiVariables = true;
        time.timeZone = "Europe/London";
        i18n.defaultLocale = "en_GB.UTF-8";
        zramSwap.enable = true;
        services.tailscale = {
            enable = true;
            openFirewall = true;
        };
    };
}
