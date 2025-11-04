{self, ...}: {
    flake.modules.nixos.substituters = {
        imports = [self.modules.generic.system-core-substituters];
    };

    flake.modules.darwin.substituters = {
        imports = [self.modules.generic.system-core-substituters];
    };

    flake.modules.generic.system-core-substituters = let
        substituters = [
            {
                url = "https://cache.nixos.org";
                publicKey = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
                priority = 1;
            }
            {
                url = "https://nix-cache.ynh.ovh";
                publicKey = "nix-cache.ynh.ovh:9qrjMrCm2hFYIuEgexkBxJTG0/6kT2jqd8muFtUezbk=";
                priority = 2;
            }
            {
                url = "https://nix-community.cachix.org";
                publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
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
            substituters = builtins.map (def: "${def.url}?priority=${toString def.priority}") substituters;
        };
    };
}
