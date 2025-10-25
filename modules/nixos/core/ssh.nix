{self, ...}: let
    inherit (import (self + /lib)) username;
in {
    flake.modules.darwin.core = {};

    flake.modules.nixos.core = {
        users.users.${username}.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwI2yD8dyhY0ga1r/bTgYBTRpkrlzT2FNKq/v+dx5// accounts@cal.rip"
        ];
        services.openssh.enable = true;
    };
}
