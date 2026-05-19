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
            bitwarden-cli
            opencode
            pkgs-stable.bitwarden-desktop
            ungoogled-chromium
        ];
        programs.thunderbird.enable = true;
    };
}
