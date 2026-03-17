topLevel @ {...}: {
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.swaylock = {};
        security.polkit.enable = true;
        services.dbus.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [
                # common libs, or leave empty to use defaults
            ];
        };
        environment.systemPackages = with pkgs; [
            topLevel.inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight
            pwvucontrol
            wl-clipboard
            brightnessctl
            iwmenu
            playerctl
            grim
            slurp
            # mpv
            nautilus
            imv
            zathura
            xwayland-satellite
            kdePackages.qtwayland
            bitwarden-cli
            bitwarden-desktop
            claude-code
            opencode
            hyprpicker
            hyprsysteminfo
            hyprpwcenter
            hyprshutdown
            tableplus
            gitkraken
            wl-screenrec
            ffmpeg
            mpv
        ];
    };
}
