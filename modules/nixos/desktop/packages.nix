topLevel @ {...}: {
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.dbus.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = [];
        };
        environment.systemPackages = with pkgs; [
            topLevel.inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight
            gelly
            ungoogled-chromium
            sourcegit
            opencode
            bitwarden-cli
            bitwarden-desktop
        ];
        programs.thunderbird.enable = true;
    };
}
