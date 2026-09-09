{ inputs, ... }: {
    flake.modules.nixos.host_karla =
        {
            config,
            lib,
            modulesPath,
            pkgs,
            ...
        }:
        {
            imports = [
                (modulesPath + "/installer/scan/not-detected.nix")
                inputs.nixos-hardware.nixosModules.framework-16-7040-amd
                inputs.lanzaboote.nixosModules.lanzaboote
            ];

            environment.systemPackages = [
                # For debugging and troubleshooting Secure Boot.
                pkgs.sbctl
            ];

            # Lanzaboote replaces the systemd-boot module.
            boot.loader.systemd-boot.enable = lib.mkForce false;
            boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
            };

            boot.kernelPackages = pkgs.linuxPackages_latest;
            boot.initrd.availableKernelModules = [
                "nvme"
                "xhci_pci"
                "thunderbolt"
                "usbhid"
                "usb_storage"
                "sd_mod"
            ];
            boot.initrd.systemd.enable = true;
            boot.kernelModules = [
                "kvm-amd"
                "ntsync"
            ];
            boot.kernelParams = [
                "amd_pstate=active"
            ];

            # skip systemd-boot menu, hold space at boot to show the menu
            boot.loader.timeout = 0;

            services.xserver.videoDrivers = [ "amdgpu" ];
            systemd.services.NetworkManager-wait-online.enable = false;
            systemd.services.docker.wantedBy = lib.mkForce [ ];

            hardware.enableAllFirmware = true;
            hardware.framework.enableKmod = true;
            hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
            hardware.graphics = {
                enable = true;
                enable32Bit = true;
                extraPackages = with pkgs; [ libva ];
            };

            environment.sessionVariables = {
                AMD_VULKAN_ICD = "RADV";
                RADV_PERFTEST = "gpl,sam";
                LIBVA_DRIVER_NAME = "radeonsi";
            };

            services.scx = {
                enable = true;
                scheduler = "scx_lavd";
                extraArgs = [ "--autopilot" ];
            };

            fileSystems."/" = {
                device = "/dev/mapper/luks-023ee2dd-eacf-41e8-9032-f933736c9c3f";
                fsType = "btrfs";
            };

            boot.initrd.luks.devices."luks-023ee2dd-eacf-41e8-9032-f933736c9c3f" = {
                device = "/dev/disk/by-uuid/023ee2dd-eacf-41e8-9032-f933736c9c3f";
                crypttabExtraOpts = [ "tpm2-device=auto" ];
            };

            fileSystems."/home" = {
                device = "/dev/mapper/luks-023ee2dd-eacf-41e8-9032-f933736c9c3f";
                fsType = "btrfs";
                options = [ "subvol=home" ];
            };

            fileSystems."/nix" = {
                device = "/dev/mapper/luks-023ee2dd-eacf-41e8-9032-f933736c9c3f";
                fsType = "btrfs";
                options = [ "subvol=nix" ];
            };

            fileSystems."/boot" = {
                device = "/dev/disk/by-uuid/B9EA-152E";
                fsType = "vfat";
                options = [
                    "fmask=0077"
                    "dmask=0077"
                ];
            };

            zramSwap.enable = true;
            swapDevices = [ ];
        };
}
