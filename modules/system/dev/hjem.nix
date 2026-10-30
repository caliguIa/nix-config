{
    config,
    user,
    ...
}:
{
    flake.modules.nixos.dev = {
        hjem.users.${user.primary}.imports = [
            config.flake.modules.hjem.dev
        ];
    };
}
