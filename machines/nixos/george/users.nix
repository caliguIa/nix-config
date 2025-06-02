{
    pkgs,
    username,
    ...
}: {
    imports = [
        (import ../../../users/caligula/system.nix {
            inherit pkgs username;
            homeDirectory = "/home/${username}";
            extraGroups = ["share"];  # George-specific groups
        })
    ];

    # Machine-specific additional users and groups
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