{inputs, ...}: {
    flake.modules.homeManager.core = {config, ...}: {
        imports = [inputs.agenix.homeManagerModules.default];
        age = {
            identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
            secrets = {
                token-fastmail-vdirsyncer-carddav.file = ../../../.secrets/token-fastmail-vdirsyncer-carddav.age;
                token-fastmail-vdirsyncer-caldav.file = ../../../.secrets/token-fastmail-vdirsyncer-caldav.age;
                token-fastmail-aerc.file = ../../../.secrets/token-fastmail-aerc.age;
                token-fastmail-mbsync.file = ../../../.secrets/token-fastmail-mbsync.age;
            };
        };
    };
}
