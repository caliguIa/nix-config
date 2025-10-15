{
    username,
    lib,
    ...
}: {
    nix = {
        enable = lib.mkDefault true;
        gc = {
            automatic = lib.mkDefault true;
            options = lib.mkDefault "--delete-older-than 30d";
        };
        settings = {
            trusted-users = [
                "root"
                "${username}"
            ];
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
}
