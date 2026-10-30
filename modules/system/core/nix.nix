{ user, ... }:
{
    flake.modules.nixos.core =
        {
            pkgs,
            lib,
            ...
        }:
        {
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
            programs.command-not-found.enable = false;
            system.tools.nixos-generate-config.enable = false;
            documentation = {
                enable = true;
                doc.enable = false;
                info.enable = false;
                man.enable = true;
                nixos.enable = false;
                dev.enable = false;
            };
        };
}
