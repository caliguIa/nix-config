topLevel: {
    flake.modules.homeManager.core = {
        imports = with topLevel.config.flake.modules.homeManager; [
            home-manager
            nix
        ];
    };
}
