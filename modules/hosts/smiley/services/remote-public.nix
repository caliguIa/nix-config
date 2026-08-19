{
    flake.modules.nixos.host_smiley = { config, ... }: {
        services.cloudflared = {
            enable = true;
            tunnels."517d082d-7099-4ba5-a3ff-2d8d4eca0021" = {
                credentialsFile = config.age.secrets.cloudflared-git.path;
                ingress."git.calrichards.io" = "http://localhost:3000";
                default = "http_status:404";
            };
            tunnels."4c77b017-20a4-4c80-be75-1a99bcf3794d" = {
                credentialsFile = config.age.secrets.cloudflared-media.path;
                ingress = {
                    "music.calrichards.io" = "http://localhost:4533";
                    # "audiobooks.calrichards.io" = "http://localhost:8113";
                    # "jellyfin.calrichards.io" = "http://localhost:8096";
                    # "photos.calrichards.io" = "http://localhost:2283";
                    # "books.calrichards.io" = "http://localhost:8083";
                    # "rss.calrichards.io" = "http://localhost:8087";
                };
                default = "http_status:404";
            };
        };
    };
}
