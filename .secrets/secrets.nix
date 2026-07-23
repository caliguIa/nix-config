let
    users = {
        caligula = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqh1qhmwEfKoX6jufWu2bammoitHUJaYOZuQ5nwo5Ex";
    };
    systems = {
        karla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjJuY81Rz/0IiKRMTcrD49wEedXtyUVqh63Xpv1Wj2z";
        smiley = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJUX/lSF4W+/sLzmAOS6c1eyNmshv2IyhjQmcrBW8nu";
    };
    allUsers = builtins.attrValues users;
    allSystems = builtins.attrValues systems;
in {
    "passwordfile-caligula.age".publicKeys = allUsers ++ allSystems;
    "intelephense.age".publicKeys = allUsers ++ allSystems;
    "cloudflared-media.age".publicKeys = allUsers ++ allSystems;
    "cloudflare-dns-token.age".publicKeys = allUsers ++ allSystems;
    "slskd-envars.age".publicKeys = allUsers ++ allSystems;
    "miniflux-admin.age".publicKeys = allUsers ++ allSystems;
    "restic-r2.age".publicKeys = allUsers ++ allSystems;
    "caligula-ssh-key.age".publicKeys = allUsers ++ allSystems;
    "fonts/BerkeleyMono-Regular.otf.age".publicKeys = allUsers ++ allSystems;
    "fonts/BerkeleyMono-Bold.otf.age".publicKeys = allUsers ++ allSystems;
    "fonts/BerkeleyMono-Oblique.otf.age".publicKeys = allUsers ++ allSystems;
    "fonts/BerkeleyMono-Bold-Oblique.otf.age".publicKeys = allUsers ++ allSystems;
    "fonts/BerkeleyMono-Regular.ttf.age".publicKeys = allUsers ++ allSystems;
    "fonts/BerkeleyMono-Bold.ttf.age".publicKeys = allUsers ++ allSystems;
    "fonts/BerkeleyMono-Oblique.ttf.age".publicKeys = allUsers ++ allSystems;
    "fonts/BerkeleyMono-Bold-Oblique.ttf.age".publicKeys = allUsers ++ allSystems;
}
