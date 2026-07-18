topLevel @ {inputs, ...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.nixos.core = {config, ...}: let
        inherit (config.networking) hostName;
    in {
        imports = [inputs.hjem.nixosModules.default];

        hjem = {
            users.${users.primary} = {
                enable = true;
                directory = "/home/${users.primary}";
                imports = [
                    topLevel.config.flake.modules.hjem.core
                    (topLevel.config.flake.modules.hjem."host_${hostName}" or {})
                ];
            };
        };
    };
}
