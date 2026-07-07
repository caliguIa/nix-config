{
    flake.modules.nixos.host_smiley = {config, ...}: {
        services.cloudflared = {
            enable = true;
            tunnels."4c77b017-20a4-4c80-be75-1a99bcf3794d" = {
                credentialsFile = config.age.secrets.cloudflared-media.path;
                ingress = {
                    "audiobooks.calrichards.io" = "http://localhost:8113";
                    "music.calrichards.io" = "http://localhost:4533";
                    "jellyfin.calrichards.io" = "http://localhost:8096";
                    "books.calrichards.io" = "http://localhost:8083";
                    "rss.calrichards.io" = "http://localhost:8087";
                };
                default = "http_status:404";
            };
        };
    };
}
