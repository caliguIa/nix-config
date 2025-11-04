{inputs, ...}: {
    flake.modules.darwin.secrets = {pkgs, ...}: {
        imports = [inputs.agenix.darwinModules.default];
        environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.system}.default];
    };

    flake.modules.nixos.secrets = {pkgs, ...}: {
        imports = [inputs.agenix.nixosModules.default];
        environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.system}.default];
    };
}
