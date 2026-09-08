{
    flake.modules.nixos.gui = {
        services.displayManager.sddm = {
            enable = true;
            wayland.enable = true;
        };
    };
}
