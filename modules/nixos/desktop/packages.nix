topLevel @ {...}: {
    flake.modules.darwin.system-desktop-packages = {pkgs, ...}: {
        homebrew.casks = [
            # "docker-desktop"
            "tableplus"
        ];
        environment.systemPackages = with pkgs; [
            slack
            colima
            docker
            duckdb
            claude-code
            topLevel.inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
            lima
            scooter
            yt-dlp
            (writeShellScriptBin "youtube-dl" ''
                exec ${yt-dlp}/bin/yt-dlp "$@"
            '')
        ];
    };

    flake.modules.nixos.system-desktop-packages = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            topLevel.inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
            grim
            slurp
            mpv
            nautilus
            oculante
            xwayland-satellite
            kdePackages.qtwayland
            bitwarden-cli
            bitwarden-desktop
            filen-cli
            filen-desktop
            ente-desktop
        ];

        programs.sway.enable = true;
        services.displayManager.ly.enable = false;
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.hyprlock = {};
        security.polkit.enable = true;
    };
}
