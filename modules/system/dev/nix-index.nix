{
    flake.modules.nixos.dev =
        { pkgs, ... }:
        {
            programs.nix-index.enable = true;
            programs.comma = {
                enable = true;
                enableFishIntegration = true;
            };
            environment.systemPackages = [ pkgs.comma ];
        };
}
