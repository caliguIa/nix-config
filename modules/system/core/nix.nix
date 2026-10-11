topLevel@{ user, ... }:
{
    flake.modules.nixos.core =
        {
            pkgs,
            lib,
            ...
        }:
        {
            imports = [ topLevel.inputs.nixos-core.nixosModules.nixos-core ];
            system.nixos-core.enable = true;

            nix = {
                enable = lib.mkDefault true;
                # Make builds run with low priority so system stays responsive
                daemonCPUSchedPolicy = "idle";
                daemonIOSchedClass = "idle";
                package = pkgs.nixVersions.latest;
                optimise.automatic = true;
                settings = {
                    experimental-features = [
                        "nix-command"
                        "flakes"
                    ];
                    warn-dirty = false;
                };
            };
            nixpkgs.config.allowUnfree = true;
            programs.nh = {
                enable = true;
                flake = "/home/${user.primary}/nix-config";
                clean.enable = true;
                clean.extraArgs = "--keep-since 4d --keep 3";
            };
            programs.nix-index.enable = true;
            programs.comma = {
                enable = true;
                enableFishIntegration = true;
            };
            programs.command-not-found.enable = false;
            environment.systemPackages = [ pkgs.comma ];
            documentation = {
                enable = true;
                doc.enable = false;
                man.enable = true;
                nixos.enable = false;
                dev.enable = false;
            };
        };
}
