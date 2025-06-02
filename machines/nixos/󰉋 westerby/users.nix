{
    pkgs,
    username,
    ...
}: {
    imports = [
        (import ../../../users/caligula/system.nix {
            inherit pkgs username;
            homeDirectory = "/home/${username}";
            extraGroups = ["wheel"]; # George-specific groups
        })
    ];
}

