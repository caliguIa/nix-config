{
    flake.modules.nixos.gui = { ... }: {
        services.tlp.enable = false;
        services.power-profiles-daemon.enable = true;
    };
}
