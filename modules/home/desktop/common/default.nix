{config, ...}: {
    flake.modules.homeManager.desktop-common.imports = with config.flake.modules.homeManager; [
        desktop-common-ai
        desktop-common-browser
        desktop-common-database
        desktop-common-direnv
        desktop-common-email
        desktop-common-fonts
        desktop-common-ghostty
        desktop-common-helix
        desktop-common-kitty
        desktop-common-rss
        desktop-common-theme
    ];
}
