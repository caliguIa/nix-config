{config, ...}: {
    flake.modules.nixos.core = {
        pkgs,
        inputs,
        lib,
        ...
    }: {
        nix = {
            enable = lib.mkDefault true;
            package = pkgs.nix;
            nixPath = ["nixpkgs=${inputs.nixpkgs}"];
            gc = {
                automatic = lib.mkDefault true;
                options = "--delete-older-than 30d";
            };
            settings = {
                trusted-users = [
                    "@wheel"
                    "root"
                    "${config.flake.meta.users.primary}"
                ];
                experimental-features = ["nix-command" "flakes"];
            };
            optimise.automatic = lib.mkDefault true;
        };
        nixpkgs.config.allowUnfree = true;
        system = {
            autoUpgrade = {
                enable = true;
                allowReboot = true;
                flake = "github:caliguIa/nix-config";
            };
        };
    };
}
