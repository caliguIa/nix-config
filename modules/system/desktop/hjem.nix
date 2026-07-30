{
    config,
    user,
    ...
}: {
    flake.modules.nixos.desktop = {
        hjem.users.${user.primary}.imports = [
            config.flake.modules.hjem.desktop
        ];
    };
}
