topLevel @ {...}: let
    username = topLevel.config.flake.meta.users.primary;
in {
    flake.modules.nixos.core = {config, ...}: {
        users.users.${username} = {
            name = username;
            home = "/home/${username}";
            isNormalUser = true;
            extraGroups = ["wheel" "networkmanager"];
            group = username;
            hashedPasswordFile = config.age.secrets.passwordfile-caligula.path;
        };
        users.users.root = {
            isSystemUser = true;
            hashedPasswordFile = config.age.secrets.passwordfile-caligula.path;
        };
    };
}
