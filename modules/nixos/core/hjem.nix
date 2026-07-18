topLevel @ {
    inputs,
    user,
    ...
}: {
    flake.modules.nixos.core = {config, ...}: let
        inherit (config.networking) hostName;
    in {
        imports = [inputs.hjem.nixosModules.default];

        hjem = {
            clobberByDefault = true;
            users.${user.primary} = {
                directory = "/home/${user.primary}";
                imports = [
                    topLevel.config.flake.modules.hjem.core
                    (topLevel.config.flake.modules.hjem."host_${hostName}" or {})
                ];
            };
        };
    };
}
