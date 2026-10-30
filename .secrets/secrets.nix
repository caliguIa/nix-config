let
    # The admin identity decrypts everything, and is the off-host restore path for restic-r2.
    caligula = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqh1qhmwEfKoX6jufWu2bammoitHUJaYOZuQ5nwo5Ex";
    # Host keys: each host can decrypt only the secrets it declares.
    karla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGmFBeIGL6ApYZUQ/xp8cFTiU/I7mLgVisCMVAFKg7ze";
    smiley = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJUX/lSF4W+/sLzmAOS6c1eyNmshv2IyhjQmcrBW8nu";
    tarr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvEvnhR4vWmer5jw4fD3pGlGYJG50t7ZNAm2KF6NO7d";

    to = hosts: { publicKeys = [ caligula ] ++ hosts; };
    allHosts = to [
        karla
        smiley
        tarr
    ];
    workstations = to [
        karla
        tarr
    ];
    server = to [ smiley ];
in
{
    "passwordfile-caligula.age" = allHosts;
    "caligula-ssh-key.age" = allHosts;

    "fonts/BerkeleyMono-Regular.otf.age" = workstations;
    "fonts/BerkeleyMono-Bold.otf.age" = workstations;
    "fonts/BerkeleyMono-Oblique.otf.age" = workstations;
    "fonts/BerkeleyMono-Bold-Oblique.otf.age" = workstations;

    "cloudflared-media.age" = server;
    "cloudflared-git.age" = server;
    "forgejo-caligula-password.age" = server;
    "forgejo-turnstile-secret.age" = server;
    "cloudflare-dns-token.age" = server;
    "slskd-envars.age" = server;
    "miniflux-admin.age" = server;
    "restic-r2.age" = server;
}
