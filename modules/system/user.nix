let
    username = "caligula";
in {
    flake.modules.nixos.user = {pkgs, ...}: {
        users = {
            users = {
                ${username} = {
                    group = username;
                    isNormalUser = true;
                    extraGroups = ["wheel" "networkmanager" "media"];
                    shell = pkgs.fish;
                };
                media = {
                    isSystemUser = true;
                    group = "media";
                };
            };
            groups = {
                ${username} = {};
                media = {};
            };
        };
    };

    flake.modules.darwin.user = {pkgs, ...}: {
        system.primaryUser = username;
        users.users.${username} = {
            shell = pkgs.fish;
        };
    };

    flake.modules.homeManager.user = {
        pkgs,
        lib,
        ...
    }: {
        programs.home-manager.enable = true;
        home.username = lib.mkDefault username;
        home.homeDirectory = lib.mkDefault (
            if pkgs.stdenvNoCC.isDarwin
            then "/Users/${username}"
            else "/home/${username}"
        );
        home.stateVersion = "24.11";
    };
}
