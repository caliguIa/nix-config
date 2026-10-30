{
    flake.modules.nixos.dev = {
        programs.direnv = {
            enable = true;
            enableFishIntegration = true;
            nix-direnv.enable = true;
            silent = true;
        };
    };
}
