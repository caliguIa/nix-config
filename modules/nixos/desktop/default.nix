{config, ...}: {
    flake.modules.nixos.desktop.imports = with config.flake.modules.nixos; [
        system-desktop-home
        system-desktop-keymap
        system-desktop-packages
        system-desktop-theme
        system-desktop-wm
        system-desktop-bluetooth
        system-desktop-battery
        system-desktop-clipboard
    ];
}
