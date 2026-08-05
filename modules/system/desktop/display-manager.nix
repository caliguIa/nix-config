{
    flake.modules.nixos.desktop = {
        services.displayManager.gdm.enable = true;
    };
}
