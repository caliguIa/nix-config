{
    hostname,
    username,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./services
        ./users.nix
    ];

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

    # programs.zsh.enable = true;

    services.openssh.enable = true;

    nixpkgs.config.allowUnfree = true;

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

    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;
    system.autoUpgrade.channel = "https://channels.nixos.org/nixos-unstable";

    system.stateVersion = "24.11";
}
