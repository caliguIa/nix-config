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
            thunderbird
            yt-dlp
            (writeShellScriptBin "youtube-dl" ''
                exec ${yt-dlp}/bin/yt-dlp "$@"
            '')
        ];
    };

    flake.modules.nixos.system-desktop-packages = {pkgs, ...}: let
        widevine-firefox = pkgs.stdenv.mkDerivation {
            name = "widevine-firefox";
            version = pkgs.widevine-cdm.version;

            buildCommand = ''
                mkdir -p $out/gmp-widevinecdm/system-installed
                ln -s "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json" $out/gmp-widevinecdm/system-installed/manifest.json
                ln -s "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_arm64/libwidevinecdm.so" $out/gmp-widevinecdm/system-installed/libwidevinecdm.so
            '';

            meta =
                pkgs.widevine-cdm.meta
                // {
                    platforms = ["aarch64-linux"];
                };
        };
    in {
        environment.systemPackages = with pkgs; [
            topLevel.inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
            grim
            slurp
            mpv
            nautilus
            oculante
            xwayland-satellite
            kdePackages.qtwayland
        ];

        environment.variables.MOZ_GMP_PATH = ["${widevine-firefox}/gmp-widevinecdm/system-installed"];
        programs.sway.enable = true;
        services.displayManager.ly.enable = true;
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.hyprlock = {};
        security.polkit.enable = true;
    };
}
