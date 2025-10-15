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
        ../modules/shell.nix
        ../modules/atuin.nix
        ../modules/fzf.nix
        ../modules/git.nix
        ../modules/nh.nix
        ../modules/starship.nix
        ../modules/tmux.nix
        ../modules/helix.nix
        ../modules/fonts.nix
    ];
}
