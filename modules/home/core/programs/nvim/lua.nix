{
    flake.modules.homeManager.core = {config, ...}: {
        xdg.configFile."nvim".source =
            config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/nix-config/modules/home/core/programs/nvim/lua";
    };
}
