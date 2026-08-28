{
    flake.modules.nixos.desktop = {
        services.displayManager.sddm = {
            enable = true;
            wayland.enable = true;
        };
    };
}
