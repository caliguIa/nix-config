{ inputs, ... }: {
    flake.modules.nixos.gui = { pkgs, ... }: {
        services.dbus.enable = true;
        services.mullvad-vpn.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [
            ];
        };
        programs.localsend.enable = true;
        programs.firefox = {
            enable = true;
            package = pkgs.firefox-devedition;
        };
        services.tlp.enable = false;
        services.power-profiles-daemon.enable = true;
        environment.sessionVariables = {
            OPENCODE_EXPERIMENTAL_OXFMT = "true";
            MOZ_DISABLE_RDD_SANDBOX = "1";
        };
        environment.systemPackages = with pkgs; [
            bitwarden-cli
            bitwarden-desktop
            bruno
            claude-code
            gelly
            glib.bin
            mullvad
            mullvad-vpn
            opencode
            poppler
            resvg
            slack
            spotify
            tableplus
            ungoogled-chromium
            inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight
        ];
    };
}
