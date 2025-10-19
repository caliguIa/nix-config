{...}: {
    imports = [
        ./caddy.nix
        ./samba.nix
        ./jellyfin.nix
        ./sabnzbd.nix
        ./sonarr.nix
        ./radarr.nix
        ./audiobookshelf.nix
        ./cloudflared.nix
        ./minecraft.nix
    ];
}
