topLevel @ {...}: {
    flake.modules.nixos.desktop = {
        pkgs,
        pkgs-stable,
        ...
    }: {
        services.dbus.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = [];
        };
        environment.systemPackages = with pkgs; [
            topLevel.inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight
            sourcegit
            pwvucontrol
            iwmenu
            playerctl
            imv
            zathura
            xwayland-satellite
            kdePackages.qtwayland
            bitwarden-cli
            claude-code
            opencode
            tableplus
            ffmpeg
            mpv
            kdePackages.kdeconnect-kde
            pkgs-stable.bitwarden-desktop
            ungoogled-chromium
        ];
    };
}
