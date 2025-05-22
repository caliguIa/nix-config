{
    lib,
    system,
    username,
    ...
}: let
    isDarwin = lib.strings.hasInfix "darwin" system;
    homeDirectory =
        if isDarwin
        then "/Users/${username}"
        else "/home/${username}";
in {
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
    imports = [
        ../../dots/git
        ../../dots/zsh
        ../../dots/starship
        ../../dots/fzf
        ../../dots/atuin
        ../../dots/tmux
        ../../dots/bin
    ];
    home = {
        username = username;
        homeDirectory = homeDirectory;
        file = {
            ".hushlogin".text = "";
        };
        stateVersion = "24.11";
    };
}
