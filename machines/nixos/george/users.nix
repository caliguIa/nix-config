{
    pkgs,
    username,
    ...
}: {
    imports = [
        (import ../../../users/caligula/system.nix {
            inherit pkgs username;
            homeDirectory = "/home/${username}";
            extraGroups = ["share"];
        })
    ];

    users = {
        users = {
            share = {
                isSystemUser = true;
                group = "share";
                uid = 994;
            };
        };
        groups = {
            share = {
                gid = 993;
            };
        };
    };
}

