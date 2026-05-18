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
            # xwayland-satellite
            # kdePackages.qtwayland
            bitwarden-cli
            opencode
            kdePackages.kdeconnect-kde
            pkgs-stable.bitwarden-desktop
            ungoogled-chromium
        ];
    };
}
