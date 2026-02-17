topLevel @ {inputs, ...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.nixos.core = {config, ...}: let
        inherit (config.networking) hostName;
    in {
        imports = [inputs.home-manager.nixosModules.home-manager];

        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${users.primary}.imports = [
                topLevel.config.flake.modules.homeManager.core
                (topLevel.config.flake.modules.homeManager."host_${hostName}" or {})
            ];
            extraSpecialArgs.inputs = inputs;
        };
    };
}
