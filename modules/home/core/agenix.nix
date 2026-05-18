{inputs, ...}: {
    flake.modules.homeManager.core = {config, ...}: {
        imports = [inputs.agenix.homeManagerModules.default];
        age = {
            identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
            secrets = {
                intelephense.file = ../../../.secrets/intelephense.age;
            };
        };
    };
}
