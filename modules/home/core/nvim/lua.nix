{
    flake.modules.homeManager.core = {config, ...}: {
        xdg.configFile."nvim".source = ./lua;
        # "/home/caligula/nix-config/modules/home/core/nvim/lua";
    };
}
