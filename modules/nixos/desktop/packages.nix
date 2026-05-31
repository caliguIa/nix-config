topLevel @ {...}: {
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.dbus.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = [];
        };
        # below is needed until bitwarden-desktop updates to electron-41
        # https://github.com/NixOS/nixpkgs/issues/521305
        nixpkgs.config.permittedInsecurePackages = [
            "electron-39.8.10"
        ];
        environment.systemPackages = with pkgs; [
            topLevel.inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight
            ungoogled-chromium
            gelly
            sourcegit
            opencode
            bitwarden-cli
            bitwarden-desktop
        ];
        programs.thunderbird.enable = true;
        programs.firefox = {
            enable = true;
            package = pkgs.firefox-devedition;
        };
    };
}
