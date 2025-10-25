topLevel: {
    flake.modules.darwin.core = {
        imports = with topLevel.config.flake.modules.darwin; [
            home-manager
            substituters
            nix
            users
        ];
    };

    flake.modules.nixos.core = {
        imports = with topLevel.config.flake.modules.nixos; [
            home-manager
            substituters
            nix
            users
        ];
    };
}
