let
    username = "caligula";
in {
    flake.modules.homeManager.home-manager = {
        lib,
        pkgs,
        ...
    }: {
        home.stateVersion = "24.11";
        programs.home-manager.enable = true;
        home = {
            username = lib.mkForce username;
            homeDirectory = lib.mkForce (
                if pkgs.stdenvNoCC.isDarwin
                then "/Users/${username}"
                else "/home/${username}"
            );
        };
    };
}
