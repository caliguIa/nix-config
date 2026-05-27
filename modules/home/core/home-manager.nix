{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.homeManager.core = {lib, ...}: {
        home.stateVersion = "26.05";
        programs.home-manager.enable = true;
        home = {
            username = lib.mkForce users.primary;
            homeDirectory = lib.mkForce "/home/${users.primary}";
        };
    };
}
