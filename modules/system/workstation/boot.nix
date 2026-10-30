{
    # The x86 machine profile karla and tarr share.
    flake.modules.nixos.workstation =
        { pkgs, ... }:
        {
            boot.kernelPackages = pkgs.linuxPackages_latest;
            # skip systemd-boot menu, hold space at boot to show the menu
            boot.loader.timeout = 0;
            hardware.enableAllFirmware = true;
        };
}
