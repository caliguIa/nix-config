{
    username,
    hostname,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./services
        ../../user
        ../../modules/nix-settings.nix
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

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking = {
        defaultGateway = "192.168.0.1";
        nameservers = ["8.8.8.8"];
        hostName = hostname;
        firewall.enable = true;
    };

    time.timeZone = "Europe/London";

    services.openssh.enable = true;

    security.sudo = {
        enable = true;
        extraConfig = ''
            Defaults timestamp_timeout=30
        '';
    };

    nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [
            "broadcom-sta-6.30.223.271-57-6.12.48"
        ];
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
            services.ssh-agent.enable = true;
            programs.ssh = {
                enable = true;
                addKeysToAgent = "yes";
            };
        }
    ];
}
