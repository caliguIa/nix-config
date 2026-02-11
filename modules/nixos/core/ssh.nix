{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.nixos.core = {
        users.users.${users.primary}.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwI2yD8dyhY0ga1r/bTgYBTRpkrlzT2FNKq/v+dx5// accounts@cal.rip"
        ];
        services.openssh.enable = true;
    };
}
