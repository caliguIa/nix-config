{ inputs, ... }: {
    flake.modules.nixos.host_westerby = { modulesPath, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.apple-silicon.nixosModules.apple-silicon-support
        ];
        boot.initrd.availableKernelModules = [ "usb_storage" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];
        fileSystems."/" = {
            device = "/dev/disk/by-uuid/797d66e8-19b0-4188-92d8-1250d468dd3e";
            fsType = "ext4";
        };

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/7973-1321";
            fsType = "vfat";
            options = [
                "fmask=0022"
                "dmask=0022"
            ];
        };

        swapDevices = [ ];
        nixpkgs.hostPlatform = "aarch64-linux";

        # boot.loader, time.timeZone and i18n.defaultLocale come from core (core/misc.nix).
        hardware = {
            bluetooth.enable = true;
            asahi.enable = true;
            asahi.setupAsahiSound = true;
            asahi.peripheralFirmwareDirectory = ./_firmware;
            apple.touchBar.enable = false;
        };
    };
}
