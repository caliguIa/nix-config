{
    flake.modules.nixos.host_tarr =
        {
            config,
            lib,
            pkgs,
            modulesPath,
            ...
        }:
        {
            imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

            boot.initrd.availableKernelModules = [
                "xhci_pci"
                "ahci"
                "nvme"
                "usb_storage"
                "usbhid"
                "sd_mod"
            ];
            boot.kernelPackages = pkgs.linuxPackages_latest;
            boot.kernelModules = [
                "kvm-amd"
                "ntsync"
            ];

            # skip systemd-boot menu, hold space at boot to show the menu
            boot.loader.timeout = 0;

            boot.initrd.luks.devices."luks-a647cd97-fe51-4803-a017-c095d426733b".device =
                "/dev/disk/by-uuid/a647cd97-fe51-4803-a017-c095d426733b";

            fileSystems."/" = {
                device = "/dev/mapper/luks-a647cd97-fe51-4803-a017-c095d426733b";
                fsType = "btrfs";
            };

            fileSystems."/home" = {
                device = "/dev/mapper/luks-a647cd97-fe51-4803-a017-c095d426733b";
                fsType = "btrfs";
                options = [ "subvol=home" ];
            };

            fileSystems."/nix" = {
                device = "/dev/mapper/luks-a647cd97-fe51-4803-a017-c095d426733b";
                fsType = "btrfs";
                options = [ "subvol=nix" ];
            };

            fileSystems."/boot" = {
                device = "/dev/disk/by-uuid/9E44-9801";
                fsType = "vfat";
                options = [
                    "fmask=0077"
                    "dmask=0077"
                ];
            };

            systemd.services.NetworkManager-wait-online.enable = false;
            systemd.services.docker.wantedBy = lib.mkForce [ ];

            hardware.enableAllFirmware = true;
            hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
            hardware.graphics = {
                enable = true;
                enable32Bit = true;
                extraPackages = with pkgs; [ libva ];
            };

            services.xserver.xkb.layout = "us";
            services.scx = {
                enable = true;
                scheduler = "scx_lavd";
                extraArgs = [ "--autopilot" ];
            };

            zramSwap.enable = true;
            swapDevices = [ ];
        };
}
