topLevel @ {user, ...}: {
    flake.modules.nixos.core = {
        pkgs,
        inputs,
        lib,
        ...
    }: {
        imports = [topLevel.inputs.nixos-core.nixosModules.nixos-core];
        system.nixos-core.enable = true;

        nix = let
            flakes = lib.filterAttrs (_: input: lib.isType "flake" input) inputs;
            nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakes;
        in {
            enable = lib.mkDefault true;
            # Make builds run with low priority so system stays responsive
            daemonCPUSchedPolicy = "idle";
            daemonIOSchedClass = "idle";
            package = pkgs.nixVersions.latest;
            nixPath = nixPath;
            optimise.automatic = true;
            settings = {
                experimental-features = ["nix-command" "flakes"];
                warn-dirty = false;
            };
        };
        nixpkgs.config.allowUnfree = true;
        programs.nh = {
            enable = true;
            flake = "/home/${user.primary}/nix-config";
            clean.enable = true;
        };
        programs.command-not-found.enable = false;
        documentation = {
            enable = true;
            doc.enable = false;
            man.enable = true;
            nixos.enable = false;
            dev.enable = false;
        };
    };
}
