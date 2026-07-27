{
    flake.modules.hjem.core = {
        files.".ssh/id_ed25519.pub".text = ''
            ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqh1qhmwEfKoX6jufWu2bammoitHUJaYOZuQ5nwo5Ex acc@calrichards.io
        '';
    };
}
