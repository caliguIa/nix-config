{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.nixos.desktop = {
        hjem.users.${users.primary}.imports = [
            config.flake.modules.hjem.desktop
        ];
    };
}
