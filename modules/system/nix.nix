let
    username = "caligula";
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
                substituters = [
                    "https://nix-community.cachix.org"
                    "https://cache.nixos.org"
                ];
                trusted-public-keys = [
                    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                ];
            };
        };
        nixpkgs.config.allowUnfree = true;
        system = {
            stateVersion = 4;
            checks.verifyNixPath = false;
        };
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
                substituters = [
                    "https://nix-community.cachix.org"
                    "https://cache.nixos.org"
                ];
                trusted-public-keys = [
                    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                ];
            };
        };
        nixpkgs = {
            overlays = [inputs.nix-minecraft.overlay];
            config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                    "broadcom-sta-6.30.223.271-57-6.12.53"
                ];
            };
        };
        system = {
            autoUpgrade = {
                enable = true;
                allowReboot = true;
                channel = "https://channels.nixos.org/nixos-unstable";
            };
            stateVersion = "24.11";
        };
    };
}
