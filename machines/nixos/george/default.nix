{
    inputs,
    pkgs,
    username,
    hostname,
    ...
}: let
    homeDirectory = "/home/${username}";
in {
    imports = [
        ./hardware-configuration.nix
        ./services
        (import ../../../users/caligula {
            inherit pkgs username;
            homeDirectory = homeDirectory;
        })
    ];
    users = {
        users = {
            ${username} = {
                group = "caligula";
                isNormalUser = true;
                extraGroups = ["wheel" "networkmanager" "media"];
                openssh.authorizedKeys.keys = [
                    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwI2yD8dyhY0ga1r/bTgYBTRpkrlzT2FNKq/v+dx5// accounts@cal.rip"
                ];
            };
            media = {
                isSystemUser = true;
                group = "media";
            };
        };
        groups = {
            ${username} = {};
            media = {};
        };
    };

    systemd.tmpfiles.rules = [
        "d /data 0755 root root -"
        "d /data/downloads 0755 root root -"
        "d /data/downloads/complete 0755 media media -"
        "d /data/downloads/complete/movies 0755 media media -"
        "d /data/downloads/complete/tv 0755 media media -"
        "d /data/downloads/complete/audiobooks 0755 media media -"
        "d /data/downloads/incomplete 0755 media media -"
        "d /data/media 0755 root root -"
        "d /data/media/movies 0755 media media -"
        "d /data/media/tv 0755 media media -"
        "d /data/media/audiobooks 0755 media media -"
    ];

    environment.systemPackages = with pkgs; [
        inputs.self.outputs.neovim.packages.${pkgs.system}.nvim
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking = {
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
            "broadcom-sta-6.30.223.271-57-6.12.48"
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
