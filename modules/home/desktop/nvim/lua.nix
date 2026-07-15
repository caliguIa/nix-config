{
    flake.modules.homeManager.desktop = {config, ...}: {
        xdg.configFile."nvim/pack/desktop/start/desktop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/home/desktop/nvim/lua";
    };
}
