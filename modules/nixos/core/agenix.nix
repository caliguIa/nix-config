{inputs, ...}: {
    flake.modules.nixos.core = {pkgs, ...}: {
        imports = [inputs.agenix.nixosModules.default];
        environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenvNoCC.system}.default];
        age.secrets = {
            passwordfile-caligula.file = ../../../.secrets/passwordfile-caligula.age;
        };
    };
}
