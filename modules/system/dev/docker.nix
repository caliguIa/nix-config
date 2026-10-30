{ user, ... }: {
    flake.modules.nixos.dev = { ... }: {
        virtualisation.docker = {
            enable = true;
            enableOnBoot = false;
            autoPrune.enable = true;
            daemon.settings = {
                dns = [
                    "1.1.1.1"
                    "8.8.8.8"
                ];
                log-driver = "journald";
            };
        };

        users.users.${user.primary}.extraGroups = [ "docker" ];
    };
}
