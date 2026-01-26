{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.darwin.system-desktop-home = {
        home-manager.users.${users.primary}.imports = [
            config.flake.modules.homeManager.desktop-darwin
        ];
    };

    flake.modules.nixos.system-desktop-home = {
        home-manager.users.${users.primary}.imports = [
            config.flake.modules.homeManager.desktop-linux
        ];
    };
}
