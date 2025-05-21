{
    pkgs,
    username,
    ...
}: {
    users = {
        users = {
            ${username} = {
                isNormalUser = true;
                home = "/home/${username}";
                shell = pkgs.zsh;
                extraGroups = ["wheel" "networkmanager" "docker" "share"];
            };
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

