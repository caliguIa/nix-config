{ user, secret, ... }: {
    flake.modules.nixos.core = { config, ... }: {
        age.secrets.passwordfile-caligula.file = secret "passwordfile-caligula";
        services.userborn.enable = true;
        # userborn's own trigger only covers its JSON, which holds the secret's path,
        # not its contents. Re-run it when the encrypted password changes.
        systemd.services.userborn.restartTriggers = [
            (builtins.hashFile "sha256" config.age.secrets.passwordfile-caligula.file)
        ];
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
