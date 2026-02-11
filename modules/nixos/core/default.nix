topLevel: {
    flake.modules.nixos.core = {
        imports = with topLevel.config.flake.modules.nixos; [
            home-manager
            substituters
            nix
            users
        ];
    };
}
