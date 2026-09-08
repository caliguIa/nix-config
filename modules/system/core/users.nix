{ user, ... }: {
    flake.modules.nixos.core = { config, ... }: {
        users.users.${user.primary} = {
            name = user.primary;
            home = "/home/${user.primary}";
            isNormalUser = true;
            extraGroups = [
                "wheel"
                "networkmanager"
                "audio"
                "video"
                "realtime"
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
