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
        programs.nh = {
            enable = true;
            flake = "/home/caligula/nix-config";
            clean.enable = true;
        };
    };
}
