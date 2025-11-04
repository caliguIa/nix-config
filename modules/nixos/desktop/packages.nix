topLevel @ {...}: {
    flake.modules.darwin.system-desktop-packages = {pkgs, ...}: {
        homebrew.casks = [
            "docker-desktop"
            "ghostty@tip"
            "onyx"
            "tableplus"
        ];
        environment.systemPackages = with pkgs; [
            slack
        ];
    };

    flake.modules.nixos.system-desktop-packages = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            grim
            slurp
            mpv
            networkmanagerapplet
            oculante
            wl-clipboard
            xwayland-satellite
        ];
        programs._1password-gui.enable = true;
        programs._1password-gui.polkitPolicyOwners = [topLevel.config.flake.meta.users.primary];
        programs.sway.enable = true;
        services.displayManager.ly.enable = true;
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.hyprlock = {};
        security.polkit.enable = true;
    };
}
