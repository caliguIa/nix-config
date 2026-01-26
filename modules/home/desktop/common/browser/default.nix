{config, ...}: {
    flake.modules.homeManager.desktop-common-browser.imports = with config.flake.modules.homeManager; [
        desktop-common-browser-glide
    ];
}
