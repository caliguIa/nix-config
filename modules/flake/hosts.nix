{
    inputs,
    config,
    lib,
    ...
}:
let
    prefix = "host_";
in
{
    # flake.modules.nixos.host_<name> -> nixosConfigurations.<name>. Each host's
    # hardware.nix sets nixpkgs.hostPlatform; modules close over flake-parts `inputs`.
    config.flake.nixosConfigurations = lib.mapAttrs' (
        moduleName: hostModule:
        let
            hostName = lib.removePrefix prefix moduleName;
        in
        lib.nameValuePair hostName (
            inputs.nixpkgs.lib.nixosSystem {
                modules = [
                    hostModule
                    { networking.hostName = lib.mkDefault hostName; }
                ];
            }
        )
    ) (lib.filterAttrs (name: _: lib.hasPrefix prefix name) config.flake.modules.nixos);
}
