{
    config,
    user,
    ...
}:
{
    flake.modules.nixos.gui = {
        hjem.users.${user.primary}.imports = [
            config.flake.modules.hjem.gui
        ];
    };
}
