{
    services.sonarr = {
        enable = true;
        openFirewall = true;
        user = "media";
        group = "media";
        settings = {
            server.port = 8989;
        };
    };
}
