{
    config,
    user,
    ...
}:
{
    flake.modules.nixos.sway = {
        hjem.users.${user.primary}.imports = [
            config.flake.modules.hjem.sway
        ];
    };
}
