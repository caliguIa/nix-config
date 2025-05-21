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
    imports = [
        ../../dots/git
        ../../dots/zsh
        ../../dots/nvim
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
        # if isDarwin
        # then "23.11"
        # else "24.11";
    };

    programs.home-manager.enable = true;
}
