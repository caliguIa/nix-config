{ inputs, ... }: {
    flake.modules.nixos.host_tarr =
        {
            config,
            lib,
            pkgs,
            modulesPath,
            ...
        }:
        {
            imports = [
                (modulesPath + "/installer/scan/not-detected.nix")
                inputs.lanzaboote.nixosModules.lanzaboote
            ];

            environment.systemPackages = [
                pkgs.sbctl
                pkgs.lm_sensors
            ];

            # Lanzaboote replaces the systemd-boot module.
            boot.loader.systemd-boot.enable = lib.mkForce false;
            boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
            };

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
                "nct6775"
            ];

            # skip systemd-boot menu, hold space at boot to show the menu
            boot.loader.timeout = 0;

            boot.initrd.luks.devices."luks-a647cd97-fe51-4803-a017-c095d426733b" = {
                device = "/dev/disk/by-uuid/a647cd97-fe51-4803-a017-c095d426733b";
                crypttabExtraOpts = [ "tpm2-device=auto" ];
            };

            fileSystems."/" = {
                device = "/dev/mapper/luks-a647cd97-fe51-4803-a017-c095d426733b";
                fsType = "btrfs";
                options = [
                    "noatime"
                    "compress=zstd"
                ];
            };

            fileSystems."/home" = {
                device = "/dev/mapper/luks-a647cd97-fe51-4803-a017-c095d426733b";
                fsType = "btrfs";
                options = [
                    "subvol=home"
                    "noatime"
                    "compress=zstd"
                ];
            };

            fileSystems."/nix" = {
                device = "/dev/mapper/luks-a647cd97-fe51-4803-a017-c095d426733b";
                fsType = "btrfs";
                options = [
                    "subvol=nix"
                    "noatime"
                    "compress=zstd"
                ];
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
            hardware.nvidia = {
                open = true;
                modesetting.enable = true;
                powerManagement.enable = true;
            };

            services.xserver.videoDrivers = [ "nvidia" ];
            services.xserver.xkb.layout = "us";
            services.scx = {
                enable = true;
                scheduler = "scx_lavd";
                extraArgs = [ "--autopilot" ];
            };

            services.btrfs.autoScrub = {
                enable = true;
                interval = "monthly";
                fileSystems = [ "/" ];
            };

            zramSwap.enable = true;
            swapDevices = [ ];
        };
}
