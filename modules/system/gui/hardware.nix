{
    flake.modules.nixos.gui =
        { lib, ... }:
        {
            options.boot.initrd.luks.devices = lib.mkOption {
                type = lib.types.attrsOf (
                    lib.types.submodule {
                        config.allowDiscards = lib.mkDefault true;
                    }
                );
            };

            config = {
                services.fstrim.enable = lib.mkDefault true;
            };
        };
}
