{
    services.jellyfin = {
        enable = true;
        openFirewall = true;
        user = "media";
        group = "media";
    };
}
