{ inputs, ... }:
{
    # Secrets are declared next to the module that uses them, via the `secret` helper.
    # The agenix CLI lives in the devshell.
    flake.modules.nixos.core.imports = [ inputs.agenix.nixosModules.default ];
}
