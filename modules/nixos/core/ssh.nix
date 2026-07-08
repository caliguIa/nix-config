{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.nixos.core = {
        users.users.${users.primary}.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwI2yD8dyhY0ga1r/bTgYBTRpkrlzT2FNKq/v+dx5// accounts@cal.rip"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqh1qhmwEfKoX6jufWu2bammoitHUJaYOZuQ5nwo5Ex acc@calrichards.io"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjJuY81Rz/0IiKRMTcrD49wEedXtyUVqh63Xpv1Wj2z root@karla"
        ];
        users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqh1qhmwEfKoX6jufWu2bammoitHUJaYOZuQ5nwo5Ex acc@calrichards.io"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjJuY81Rz/0IiKRMTcrD49wEedXtyUVqh63Xpv1Wj2z root@karla"
        ];
        services.openssh = {
            enable = true;
            settings = {
                PermitRootLogin = "prohibit-password";
                PasswordAuthentication = false;
            };
        };

        # Single personal identity provisioned to every host, decrypted by the
        # host key at activation. This is the private counterpart of the
        # `caligula` recipient in .secrets/secrets.nix, so it also lets any host
        # edit agenix secrets and satisfies home-manager's identityPaths.
        systemd.tmpfiles.rules = [
            "d /home/${users.primary}/.ssh 0700 ${users.primary} ${users.primary} -"
        ];
        age.secrets.caligula-ssh-key = {
            file = ../../../.secrets/caligula-ssh-key.age;
            path = "/home/${users.primary}/.ssh/id_ed25519";
            owner = users.primary;
            group = users.primary;
            mode = "600";
        };
    };
}
