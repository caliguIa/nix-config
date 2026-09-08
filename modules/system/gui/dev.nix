{
    flake.modules.nixos.gui = {
        programs.direnv = {
            enable = true;
            enableFishIntegration = true;
            nix-direnv.enable = true;
            silent = true;
        };
    };
}
