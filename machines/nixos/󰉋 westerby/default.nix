{
    hostname,
    username,
    pkgs,
    ...
}: {
    imports = [
        ./services
        ./users.nix
        ./packages.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking = {
        hostName = hostname;
    };

    time.timeZone = "Europe/London";

    services.openssh.enable = true;

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = import ../../../modules/common/packages.nix {inherit pkgs;};
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
