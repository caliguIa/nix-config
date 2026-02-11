{config, ...}: {
    flake.modules.nixos.nix = {
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
                warn-dirty = false;
            };
            optimise.automatic = lib.mkDefault true;
        };
        nixpkgs.config.allowUnfree = true;
        system = {
            autoUpgrade = {
                enable = true;
                allowReboot = true;
                channel = "https://channels.nixos.org/nixos-unstable";
            };
        };
    };
}
