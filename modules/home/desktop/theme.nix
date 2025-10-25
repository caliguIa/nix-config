{inputs, ...}: {
    flake.modules.homeManager.desktop = {
        pkgs,
        lib,
        ...
    }: {
        stylix = {
            targets = {
                bat.enable = true;
                fish.enable = true;
                fzf.enable = true;
                ghostty.enable = true;
                helix.enable = true;
                neovim.enable = true;
                starship.enable = true;
                tmux.enable = true;
                yazi.enable = true;
            };
        };
    };
}
