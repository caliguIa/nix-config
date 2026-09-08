{
    flake.modules.nixos.host_tarr = { config, lib, pkgs, modulesPath, ... }: {
	  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

	  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
	  boot.initrd.kernelModules = [ ];
	  boot.kernelModules = [ "kvm-amd" ];
	  boot.extraModulePackages = [ ];

	  fileSystems."/" =
	    { device = "/dev/mapper/luks-a647cd97-fe51-4803-a017-c095d426733b";
	      fsType = "btrfs";
	    };

	  boot.initrd.luks.devices."luks-a647cd97-fe51-4803-a017-c095d426733b".device = "/dev/disk/by-uuid/a647cd97-fe51-4803-a017-c095d426733b";

	  fileSystems."/home" =
	    { device = "/dev/mapper/luks-a647cd97-fe51-4803-a017-c095d426733b";
	      fsType = "btrfs";
	      options = [ "subvol=home" ];
	    };

	  fileSystems."/nix" =
	    { device = "/dev/mapper/luks-a647cd97-fe51-4803-a017-c095d426733b";
	      fsType = "btrfs";
	      options = [ "subvol=nix" ];
	    };

	  fileSystems."/boot" =
	    { device = "/dev/disk/by-uuid/9E44-9801";
	      fsType = "vfat";
	      options = [ "fmask=0077" "dmask=0077" ];
	    };

	  swapDevices = [ ];

	  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
