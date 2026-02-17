{
    flake.modules.nixos.core = {lib, ...}: let
        substituters = [
            {
                url = "https://cache.nixos.org";
                publicKey = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
                priority = 1;
            }
            {
                url = "https://nix-community.cachix.org";
                publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
                priority = 2;
            }
            {
                url = "https://hyprland.cachix.org";
                publicKey = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
                priority = 3;
            }
            {
                url = "https://nixos-apple-silicon.cachix.org";
                publicKey = "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20=";
                priority = 4;
            }
        ];
    in {
        nix.settings = {
            trusted-public-keys = builtins.catAttrs "publicKey" substituters;
            substituters = lib.mkForce (map (def: "${def.url}?priority=${toString def.priority}") substituters);
            fallback = true;
            connect-timeout = 5;
            warn-dirty = false;
            max-substitution-jobs = 16;
            http-connections = 25;
        };
    };
}
