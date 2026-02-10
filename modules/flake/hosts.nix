{
    inputs,
    config,
    ...
}: {
    config = {
        flake.nixosConfigurations.karla = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs.inputs = inputs;
            modules = [
                inputs.self.modules.nixos.core
                (config.flake.modules.nixos.host_karla or {})
                (config.flake.modules.homeManager.host_karla or {})
            ];
        };
    
        flake.darwinConfigurations.polyakov = inputs.nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs.inputs = inputs;
            modules = [
                config.flake.modules.darwin.core
                (config.flake.modules.darwin.host_polyakov or {})
            ];
        };

        flake.nixosConfigurations.george = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs.inputs = inputs;
            modules = [
                inputs.self.modules.nixos.core
                (config.flake.modules.nixos.host_george or {})
            ];
        };

        flake.nixosConfigurations.westerby = inputs.nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs.inputs = inputs;
            modules = [
                inputs.self.modules.nixos.core
                (config.flake.modules.nixos.host_westerby or {})
                (config.flake.modules.homeManager.host_westerby or {})
            ];
        };
    };
}
