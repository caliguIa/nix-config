{ inputs, ... }: {
    flake.modules.nixos.desktop = { pkgs, ... }: {
        services.dbus.enable = true;
        services.mullvad-vpn.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = [ ];
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
            claude-code
            gelly
            mullvad
            mullvad-vpn
            opencode
            ungoogled-chromium
            inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight
        ];
    };
}
