topLevel @ {...}: {
    flake.modules.nixos.system-desktop-packages = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            topLevel.inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
            pwvucontrol
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
            filen-cli
            filen-desktop
            ente-desktop
            claude-code
        ];

        services.gnome.gnome-keyring.enable = true;
        security.pam.services.hyprlock = {};
        security.polkit.enable = true;
    };
}
