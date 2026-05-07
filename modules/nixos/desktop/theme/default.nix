{inputs, ...}: {
    flake.modules.nixos.desktop = {pkgs, ...}: {
        # Install the monospace font system-wide
        fonts.packages = [
            inputs.fonts.packages.${pkgs.stdenvNoCC.system}.berkeley-mono
            pkgs.dm-sans
        ];
    };
}
