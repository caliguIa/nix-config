topLevel@{
    inputs,
    user,
    ...
}:
{
    flake.modules.nixos.core = {
        imports = [ inputs.hjem.nixosModules.default ];

        hjem = {
            clobberByDefault = true;
            users.${user.primary} = {
                directory = "/home/${user.primary}";
                imports = [ topLevel.config.flake.modules.hjem.core ];
            };
        };
    };
}
