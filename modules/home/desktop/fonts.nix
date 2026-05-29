{inputs, ...}: {
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        home.packages = with pkgs; [
            inputs.fonts.packages.${pkgs.stdenvNoCC.system}.berkeley-mono
            nerd-fonts.symbols-only
        ];
    };
}
