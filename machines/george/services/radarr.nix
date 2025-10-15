{
    services.radarr = {
        enable = true;
        openFirewall = true;
        user = "media";
        group = "media";
        settings = {
            server.port = 7878;
        };
    };
}
