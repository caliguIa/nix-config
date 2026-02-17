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
                (config.flake.modules.nixos.host_karla or {})
                inputs.nixos-hardware.nixosModules.framework-16-7040-amd
            ];
        };

        flake.nixosConfigurations.george = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs.inputs = inputs;
            modules = [ (config.flake.modules.nixos.host_george or {}) ];
        };

        flake.nixosConfigurations.westerby = inputs.nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs.inputs = inputs;
            modules = [ (config.flake.modules.nixos.host_westerby or {}) ];
        };
    };
}
