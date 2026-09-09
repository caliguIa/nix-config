{
    flake.modules.nixos.gui = { lib, ... }: {
        services.fstrim.enable = lib.mkDefault true;
    };
}
