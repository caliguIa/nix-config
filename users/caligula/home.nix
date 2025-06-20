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
        ../../modules/common/fish
        ../../modules/common/zsh
        ../../modules/common/atuin
        ../../modules/common/fzf
        ../../modules/common/git
        ../../modules/common/starship
        ../../modules/common/tmux
        ../../modules/common/fonts
    ];
}
