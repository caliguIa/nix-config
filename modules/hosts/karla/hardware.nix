{
    flake.modules.nixos.host_karla = {
        config,
        lib,
        modulesPath,
        pkgs,
        ...
    }: {
        imports = [(modulesPath + "/installer/scan/not-detected.nix")];

        boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod"];
        boot.initrd.kernelModules = [];
        boot.kernelModules = ["kvm-amd"];
        boot.extraModulePackages = [];
        boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

        hardware.framework.enableKmod = true;
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        fileSystems."/" = {
            device = "/dev/disk/by-uuid/e4dd47e6-8455-417d-98e1-e99c0ea0f360";
            fsType = "ext4";
        };

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/ED19-D1D2";
            fsType = "vfat";
            options = ["fmask=0077" "dmask=0077"];
        };

        swapDevices = [
            {device = "/dev/disk/by-uuid/830029dd-1bdc-46d7-9d31-632f42ba80c7";}
        ];
    };
}
