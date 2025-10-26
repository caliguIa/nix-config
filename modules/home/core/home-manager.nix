{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.homeManager.home-manager = {
        lib,
        pkgs,
        ...
    }: {
        home.stateVersion = "24.11";
        programs.home-manager.enable = true;
        home = {
            username = lib.mkForce users.primary;
            homeDirectory = lib.mkForce (
                if pkgs.stdenvNoCC.isDarwin
                then "/Users/${users.primary}"
                else "/home/${users.primary}"
            );
        };
    };
}
