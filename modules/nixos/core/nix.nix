{self, ...}: let
    inherit (import (self + /lib)) username;
in {
    flake.modules.darwin.nix = {
        imports = [self.modules.generic.system-core-nix];
        nix.enable = false;
        nix.gc.automatic = false;
    };

    flake.modules.nixos.nix = {
        imports = [self.modules.generic.system-core-nix];
        system = {
            autoUpgrade = {
                enable = true;
                allowReboot = true;
                channel = "https://channels.nixos.org/nixos-unstable";
            };
        };
    };

    flake.modules.generic.system-core-nix = {
        inputs,
        lib,
        ...
    }: {
        nix = {
            enable = lib.mkDefault true;
            nixPath = ["nixpkgs=${inputs.nixpkgs}"];
            gc = {
                automatic = lib.mkDefault true;
                options = "--delete-older-than 30d";
            };
            settings = {
                trusted-users = [
                    "@wheel"
                    "root"
                    "${username}"
                ];
                auto-optimise-store = true;
                experimental-features = ["nix-command" "flakes"];
                warn-dirty = false;
            };
        };
        nixpkgs.config.allowUnfree = true;
    };
}
