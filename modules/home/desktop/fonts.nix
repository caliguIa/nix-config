{inputs, ...}: {
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        fonts.fontconfig.enable = true;
        home.packages = with pkgs; [
            inputs.fonts.packages.${pkgs.stdenvNoCC.system}.berkeley-mono
            nerd-fonts.symbols-only
            material-symbols
            dm-sans
            inter
        ];
    };
}
