{inputs, ...}: {
    flake.modules.hjem.desktop = {pkgs, ...}: {
        packages = with pkgs; [
            inputs.fonts.packages.${pkgs.stdenvNoCC.system}.berkeley-mono
            nerd-fonts.symbols-only
        ];
    };
}
