{
    config,
    user,
    ...
}:
{
    flake.modules.nixos.laptop = {
        hjem.users.${user.primary}.imports = [
            config.flake.modules.hjem.laptop
        ];
    };
}
