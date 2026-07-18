{config, ...}: let
    users = config.flake.meta.users;
    home = "/home/${users.primary}";
in {
    flake.modules.hjem.core = {
        files = {
            ".config/nvim/init.lua".source = "${home}/nix-config/modules/home/core/nvim/lua/init.lua";
            ".config/nvim/after".source = "${home}/nix-config/modules/home/core/nvim/lua/after";
            ".config/nvim/plugin".source = "${home}/nix-config/modules/home/core/nvim/lua/plugin";
        };
    };
}
