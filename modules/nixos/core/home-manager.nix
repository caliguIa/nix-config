topLevel @ {
    inputs,
    self,
    ...
}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.darwin.home-manager = {
        imports = [
            inputs.home-manager.darwinModules.home-manager
            self.modules.generic.system-core-home
        ];
    };

    flake.modules.nixos.home-manager = {
        imports = [
            inputs.home-manager.nixosModules.home-manager
            self.modules.generic.system-core-home
        ];
    };

    flake.modules.generic.system-core-home = {config, ...}: let
        inherit (config.networking) hostName;
    in {
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${users.primary}.imports = [
                topLevel.config.flake.modules.homeManager.core
                (topLevel.config.flake.modules.homeManager."host_${hostName}" or {})
                # inputs.nixCats.homeModule
            ];
            extraSpecialArgs.inputs = inputs;
        };
    };
}
