{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.homeManager.home-manager = {lib, ...}: {
        home.stateVersion = "24.11";
        programs.home-manager.enable = true;
        home = {
            username = lib.mkForce users.primary;
            homeDirectory = lib.mkForce "/home/${users.primary}";
        };
    };
}
