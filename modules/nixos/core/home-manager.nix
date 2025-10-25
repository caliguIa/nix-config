topLevel @ {inputs, ...}: {
    flake.modules.darwin.home-manager = {config, ...}: let
        inherit (config.networking) hostName;
    in {
        imports = [
            inputs.home-manager.darwinModules.home-manager
        ];
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.caligula.imports = [
                topLevel.config.flake.modules.homeManager.core
                (topLevel.config.flake.modules.homeManager."host_${hostName}" or {})
                inputs.nixCats.homeModule
            ];
            extraSpecialArgs = {
                inputs = inputs;
                configName = "darwin_${hostName}";
                nhSwitchCommand = "nh darwin switch";
            };
        };
    };

    flake.modules.nixos.home-manager = {config, ...}: let
        inherit (config.networking) hostName;
    in {
        imports = [
            inputs.home-manager.nixosModules.home-manager
            # inputs.nixCats.homeModule
        ];
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.caligula.imports = [
                topLevel.config.flake.modules.homeManager.core
                (topLevel.config.flake.modules.homeManager."host_${hostName}" or {})
            ];
            extraSpecialArgs = {
                inputs = inputs;
                configName = "nixos_${hostName}";
            };
        };
    };
}
