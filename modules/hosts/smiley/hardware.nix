{
    flake.modules.nixos.host_smiley = {
        config,
        lib,
        modulesPath,
        ...
    }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "uas" "sd_mod" "sdhci_pci"];
        boot.initrd.systemd.enable = true;
        boot.kernelModules = ["kvm-intel"];

        fileSystems."/" = {
            device = "/dev/disk/by-uuid/c96ccbd3-44a6-4f82-bd87-5e77ee5ebfdc";
            fsType = "ext4";
            options = ["noatime"];
        };

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/EDD3-5C97";
            fsType = "vfat";
            options = ["fmask=0077" "dmask=0077"];
        };

        swapDevices = [
            {device = "/dev/disk/by-uuid/f61df574-ebc2-4430-ad1f-ddb1a919bd8a";}
        ];
        zramSwap.enable = true;

        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        hardware.enableRedistributableFirmware = true;

        services.fstrim.enable = true; # weekly TRIM, longevity/perf
    };
}
