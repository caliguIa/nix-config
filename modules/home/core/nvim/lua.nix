{
    flake.modules.homeManager.core = {config, ...}: {
        xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/home/core/nvim/lua/init.lua";
        xdg.configFile."nvim/after".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/home/core/nvim/lua/after";
        xdg.configFile."nvim/plugin".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/home/core/nvim/lua/plugin";
    };
}
