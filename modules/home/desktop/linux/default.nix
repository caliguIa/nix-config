{config, ...}: {
    flake.modules.homeManager.desktop-linux.imports = with config.flake.modules.homeManager; [
        desktop-common
        desktop-linux-waybar
        desktop-linux-wlogout
        desktop-linux-browser
        desktop-linux-cursor
        desktop-linux-hyprlock
        desktop-linux-kickoff
        desktop-linux-mako
        desktop-linux-window-manager
    ];
}
