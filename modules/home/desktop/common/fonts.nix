{inputs, ...}: {
    flake.modules.homeManager.desktop-common-fonts = {pkgs, ...}: {
        fonts.fontconfig.enable = true;
        home.packages = [
            inputs.fonts.packages.${pkgs.stdenv.system}.berkeley-mono
            pkgs.nerd-fonts.symbols-only
            pkgs.font-awesome
        ];
    };
}
