{
    flake.modules.nixos.desktop = {
        services.displayManager = {
            plasma-login-manager.enable = true;
        };
    };
}
