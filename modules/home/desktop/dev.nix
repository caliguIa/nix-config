{
    flake.modules.hjem.desktop = {pkgs, ...}: {
        packages = with pkgs; [
            direnv
            nix-direnv
        ];
        xdg.config.files."direnv/direnvrc".text = ''
            source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
        '';
    };
}
