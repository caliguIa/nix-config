{
    flake.modules.homeManager.nix = {pkgs, ...}: {
        nix.package = pkgs.nix;
        nix.settings = {
            warn-dirty = false;
            experimental-features = "nix-command flakes";
        };
    };
}
