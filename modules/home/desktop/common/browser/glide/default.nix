{
    flake.modules.homeManager.desktop-common-browser-glide = {config, ...}: {
        xdg.configFile."glide/glide.ts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/home/desktop/common/broswer/glide/glide.ts";
    };
}
