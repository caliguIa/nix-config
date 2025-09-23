{
    username,
    homeDirectory,
    ...
}: {
    programs.home-manager.enable = true;
    home = {
        username = username;
        homeDirectory = homeDirectory;
        stateVersion = "24.11";
        file = {".hushlogin".text = "";};
    };
    imports = [
        ../../modules/common/fish.nix
        ../../modules/common/zsh.nix
        ../../modules/common/atuin.nix
        ../../modules/common/fzf.nix
        ../../modules/common/git.nix
        ../../modules/common/nh.nix
        ../../modules/common/starship.nix
        ../../modules/common/tmux.nix
        ../../modules/common/helix.nix
        ../../modules/common/fonts.nix
    ];
}
