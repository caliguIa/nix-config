{
    hostname,
    username,
    pkgs,
    modulesPath,
    lib,
    ...
}: {
    imports = [
        ./packages.nix
        (import ../../../users/caligula {
            inherit pkgs username;
            homeDirectory = "/home/${username}";
        })
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

    environment.systemPackages = import ../../../modules/common/packages.nix {inherit pkgs;};
    nix = {
        enable = true;
        settings = {
            trusted-users = [
                "root"
                "${username}"
            ];
            experimental-features = ["nix-command" "flakes"];
            substituters = [
                "https://nix-community.cachix.org"
                "https://cache.nixos.org"
            ];
            trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];
        };

        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
        };

        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;
    system.autoUpgrade.channel = "https://channels.nixos.org/nixos-unstable";
    system.stateVersion = "25.05";
}
