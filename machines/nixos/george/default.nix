{
    pkgs,
    username,
    hostname,
    ...
}: let
    homeDirectory = "/home/${username}";
in {
    imports = [
        ./hardware-configuration.nix
        ./packages.nix
        ./services
        ./users.nix
        (import ../../../users/caligula {
            inherit pkgs username;
            homeDirectory = homeDirectory;
        })
    ];

    users = {
        users.${username} = {
            group = "caligula";
            isNormalUser = true;
            extraGroups = ["wheel" "networkmanager"];
        };
        groups.${username} = {};
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking = {
        interfaces.eth0.ipv4.addresses = [
            {
                address = "192.168.1.1";
                prefixLength = 24;
            }
        ];
        defaultGateway = "192.168.0.1";
        nameservers = ["8.8.8.8"];
        hostName = hostname;
        firewall.enable = false;
    };

    time.timeZone = "Europe/London";

    services.openssh.enable = true;

    nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [
            "broadcom-sta-6.30.223.271-57-6.12.46"
        ];
    };

    nix = {
        enable = true;
        settings = {
            trusted-users = [
                "root"
                "${username}"
            ];
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

    system = {
        autoUpgrade = {
            enable = true;
            allowReboot = true;
            channel = "https://channels.nixos.org/nixos-unstable";
        };
        stateVersion = "24.11";
    };

    home-manager.sharedModules = [
        {
            imports = [];
        }
    ];
}
