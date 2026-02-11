{config, ...}: {
    flake.modules.homeManager.desktop-common.imports = with config.flake.modules.homeManager; [
        desktop-common-database
        desktop-common-direnv
        # desktop-common-email
        desktop-common-fonts
        desktop-common-kitty
        desktop-common-rss
        desktop-common-theme
    ];
}
