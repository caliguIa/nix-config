{config, ...}: {
    flake.modules.darwin.desktop.imports = with config.flake.modules.darwin; [
        system-desktop-home
        system-desktop-homebrew
        system-desktop-keymap
        system-desktop-mouse
        system-desktop-packages
        system-desktop-theme
        system-desktop-wm
    ];

    flake.modules.nixos.desktop.imports = with config.flake.modules.nixos; [
        system-desktop-home
        system-desktop-keymap
        system-desktop-mouse
        system-desktop-packages
        system-desktop-theme
        system-desktop-wm
    ];
}
