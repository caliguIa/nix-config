{inputs, ...}: {
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.dbus.enable = true;
        services.mullvad-vpn.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = [];
        };
        programs.thunderbird.enable = true;
        programs.firefox = {
            enable = false;
            package = pkgs.firefox-devedition;
        };
        # below is needed until bitwarden-desktop updates to electron-41
        # https://github.com/NixOS/nixpkgs/issues/521305
        # electron_39-bin uses the prebuilt binary instead of building from
        # source; it is still EOL-flagged so the insecure allow stays.
        nixpkgs.overlays = [
            (final: prev: {
                bitwarden-desktop = prev.bitwarden-desktop.override {
                    electron_39 = final.electron_39-bin;
                };
            })
        ];
        nixpkgs.config.permittedInsecurePackages = [
            "electron-39.8.10"
        ];

        environment.sessionVariables.OPENCODE_EXPERIMENTAL_OXFMT = "true";
        environment.systemPackages = with pkgs; [
            inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight
            ungoogled-chromium
            gelly
            sourcegit
            opencode
            claude-code
            bitwarden-cli
            bitwarden-desktop
            mullvad-vpn
            mullvad
        ];
    };
}
