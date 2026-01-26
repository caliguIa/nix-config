{config, ...}: {
    flake.modules.homeManager.desktop-darwin.imports = with config.flake.modules.homeManager; [
        desktop-common
    ];
}
