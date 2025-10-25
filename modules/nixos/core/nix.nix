{self, ...}: let
    inherit (import (self + /lib)) username;
in {
    flake.modules.darwin.nix = {inputs, ...}: {
        nix = {
            enable = false;
            nixPath = ["nixpkgs=${inputs.nixpkgs}"];
            gc.automatic = false;
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

    flake.modules.nixos.nix = {inputs, ...}: {
        nix = {
            enable = true;
            nixPath = ["nixpkgs=${inputs.nixpkgs}"];
            gc = {
                automatic = true;
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
        system = {
            autoUpgrade = {
                enable = true;
                allowReboot = true;
                channel = "https://channels.nixos.org/nixos-unstable";
            };
        };
    };
}
