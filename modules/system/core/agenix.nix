{ inputs, ... }:
{
    # Secrets are declared next to the module that uses them, via the `secret` helper.
    flake.modules.nixos.core = { pkgs, ... }: {
        imports = [ inputs.agenix.nixosModules.default ];
        environment.systemPackages = [ inputs.agenix.packages.${pkgs.stdenvNoCC.system}.default ];
    };
}
