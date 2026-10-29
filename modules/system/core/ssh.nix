{ user, ... }: {
    flake.modules.nixos.core = {
        users.users.${user.primary}.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwI2yD8dyhY0ga1r/bTgYBTRpkrlzT2FNKq/v+dx5// accounts@cal.rip"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqh1qhmwEfKoX6jufWu2bammoitHUJaYOZuQ5nwo5Ex acc@calrichards.io"
        ];
        users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqh1qhmwEfKoX6jufWu2bammoitHUJaYOZuQ5nwo5Ex acc@calrichards.io"
        ];
        services.openssh = {
            enable = true;
            # Port 22 only over the tailnet; smiley also opens it on its LAN.
            openFirewall = false;
            settings = {
                PermitRootLogin = "prohibit-password";
                PasswordAuthentication = false;
            };
        };
        networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

        systemd.tmpfiles.rules = [
            "d /home/${user.primary}/.ssh 0700 ${user.primary} ${user.primary} -"
        ];
        age.secrets.caligula-ssh-key = {
            file = ../../../.secrets/caligula-ssh-key.age;
            path = "/home/${user.primary}/.ssh/id_ed25519";
            owner = user.primary;
            group = user.primary;
            mode = "600";
        };
    };

    flake.modules.hjem.core = {
        files.".ssh/id_ed25519.pub".text = ''
            ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqh1qhmwEfKoX6jufWu2bammoitHUJaYOZuQ5nwo5Ex acc@calrichards.io
        '';
    };
}
