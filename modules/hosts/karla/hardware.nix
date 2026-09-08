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
            ];

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
                device = "/dev/disk/by-uuid/e4dd47e6-8455-417d-98e1-e99c0ea0f360";
                fsType = "ext4";
                options = [ "noatime" ];
            };

            fileSystems."/boot" = {
                device = "/dev/disk/by-uuid/ED19-D1D2";
                fsType = "vfat";
                options = [
                    "fmask=0077"
                    "dmask=0077"
                ];
            };

            zramSwap.enable = true;
            swapDevices = [
                { device = "/dev/disk/by-uuid/830029dd-1bdc-46d7-9d31-632f42ba80c7"; }
            ];
        };
}
