{config, ...}: let
    users = config.flake.meta.users;
    home = "/home/${users.primary}";
in {
    flake.modules.hjem.desktop = {
        files.".config/nvim/pack/desktop/start/desktop".source = "${home}/nix-config/modules/home/desktop/nvim/lua";
    };
}
