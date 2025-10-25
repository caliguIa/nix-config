{inputs, ...}: {
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        fonts.fontconfig.enable = true;
        home.packages = [
            inputs.fonts.packages.${pkgs.system}.berkeley-mono
            pkgs.nerd-fonts.symbols-only
        ];
    };
}
