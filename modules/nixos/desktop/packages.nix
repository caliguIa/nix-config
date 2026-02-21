topLevel @ {...}: {
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.hyprlock = {};
        security.polkit.enable = true;
        services.dbus.enable = true;
        programs.dconf.enable = true;
        environment.systemPackages = with pkgs; [
            topLevel.inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight
            pwvucontrol
            wl-clipboard
            brightnessctl
            playerctl
            grim
            slurp
            mpv
            nautilus
            imv
            zathura
            xwayland-satellite
            kdePackages.qtwayland
            bitwarden-cli
            bitwarden-desktop
            claude-code
            hyprpicker
            hyprsysteminfo
            hyprpwcenter
            hyprshutdown
            tableplus
        ];
    };
}
