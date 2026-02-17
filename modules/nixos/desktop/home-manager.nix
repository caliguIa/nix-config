{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.nixos.desktop = {
        home-manager.users.${users.primary}.imports = [
            config.flake.modules.homeManager.desktop
        ];
    };
}
