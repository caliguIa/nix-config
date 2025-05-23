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
        ../../modules/common/git
        ../../modules/common/zsh
        ../../modules/common/starship
        ../../modules/common/fzf
        ../../modules/common/atuin
        ../../modules/common/tmux
    ];
    home = {
        username = username;
        homeDirectory = homeDirectory;
        file = {".hushlogin".text = "";};
        stateVersion = "24.11";
    };
}
