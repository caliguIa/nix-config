{
    hostname,
    username,
    pkgs,
    modulesPath,
    lib,
    ...
}: {
    imports = [
        ../../user
        ../../lib/nix-settings.nix
        (modulesPath + "/profiles/qemu-guest.nix")
        ./lima-init.nix
    ];

    networking = {
        hostName = hostname;
    };

    time.timeZone = "Europe/London";

    services.openssh.enable = true;
    services.lima.enable = true;
    services.openssh.settings.PermitRootLogin = "yes";
    users.users.root.password = "nixos";

    security = {
        sudo.wheelNeedsPassword = false;
    };

    boot.loader.grub = {
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
    };
    fileSystems."/boot" = {
        device = lib.mkForce "/dev/vda1"; # /dev/disk/by-label/ESP
        fsType = "vfat";
    };
    fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        autoResize = true;
        fsType = "ext4";
        options = ["noatime" "nodiratime" "discard"];
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;
    nixpkgs.config.allowUnfree = true;

    users.users.${username} = {
        isNormalUser = true;
        extraGroups = ["wheel"];
    };

    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;
    system.autoUpgrade.channel = "https://channels.nixos.org/nixos-unstable";
    system.stateVersion = "25.05";
}
