{inputs, ...}: {
    flake.modules.nixos.host_karla = {
        config,
        lib,
        modulesPath,
        pkgs,
        ...
    }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.nixos-hardware.nixosModules.framework-16-7040-amd
        ];

        boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod"];
        boot.initrd.systemd.enable = true;
        boot.kernelModules = ["kvm-amd"];
        boot.kernelParams = [
            "amdgpu.dcdebugmask=0x410"
            "amdgpu.runpm=0"
        ];

        # skip systemd-boot menu wait; hold `space` at boot to show the menu
        boot.loader.timeout = 0;

        # don't block boot waiting for a network lease
        systemd.services.NetworkManager-wait-online.enable = false;

        # socket-activate docker instead of starting it at boot
        systemd.services.docker.wantedBy = lib.mkForce [];

        hardware.enableAllFirmware = true;
        hardware.framework.enableKmod = true;
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        fileSystems."/" = {
            device = "/dev/disk/by-uuid/e4dd47e6-8455-417d-98e1-e99c0ea0f360";
            fsType = "ext4";
            options = ["noatime"];
        };

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/ED19-D1D2";
            fsType = "vfat";
            options = ["fmask=0077" "dmask=0077"];
        };

        zramSwap.enable = true;
        swapDevices = [
            {device = "/dev/disk/by-uuid/830029dd-1bdc-46d7-9d31-632f42ba80c7";}
        ];

        services.udev.extraRules = ''
            # Arm every USB hub (physical + root) so the wake signal can propagate up the tree
            ACTION=="add|change", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="09", ATTR{power/wakeup}="enabled"

            # Logitech Unifying/Bolt receiver — the wake device
            ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c52b", ATTR{power/wakeup}="enabled"

            # xHCI host controllers at the PCI level
            ACTION=="add|change", SUBSYSTEM=="pci", DRIVER=="xhci_hcd", ATTR{power/wakeup}="enabled"
        '';
    };
}
