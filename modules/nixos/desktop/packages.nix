{
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
            xwayland-satellite
            grim
            slurp
            wl-clipboard
        ];
        programs.sway.enable = true;
        services.displayManager.ly.enable = true;
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.swaylock = {};
        security.polkit.enable = true;
    };
}
