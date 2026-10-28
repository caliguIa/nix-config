{ user, ... }: {
    flake.modules.nixos.core = { config, ... }: {
        services.userborn.enable = true;
        users.mutableUsers = false;
        users.users.${user.primary} = {
            name = user.primary;
            home = "/home/${user.primary}";
            isNormalUser = true;
            extraGroups = [
                "wheel"
                "networkmanager"
                "audio"
                "video"
            ];
            group = user.primary;
            hashedPasswordFile = config.age.secrets.passwordfile-caligula.path;
        };
        users.users.root = {
            isSystemUser = true;
            hashedPasswordFile = config.age.secrets.passwordfile-caligula.path;
        };
        users.groups.${user.primary} = { };
    };
}
