{
    flake.modules.nixos.desktop = {
        programs.direnv = {
            enable = true;
            enableFishIntegration = true;
            nix-direnv.enable = true;
            silent = true;
        };
    };
}
