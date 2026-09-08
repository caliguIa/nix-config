{ user, ... }: {
    flake.modules.nixos.gui = {
        virtualisation.docker = {
            enable = true;
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
