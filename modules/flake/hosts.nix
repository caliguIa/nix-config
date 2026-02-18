{
    inputs,
    config,
    lib,
    ...
}: let
    hosts = {
        karla = "x86_64-linux";
        george = "x86_64-linux";
        westerby = "aarch64-linux";
    };
in {
    config = {
        flake.nixosConfigurations = lib.mapAttrs (name: system:
            inputs.nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs.inputs = inputs;
                modules = [(config.flake.modules.nixos."host_${name}" or {})];
            })
        hosts;
    };
}
