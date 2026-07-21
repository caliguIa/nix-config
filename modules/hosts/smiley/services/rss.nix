{
    flake.modules.nixos.host_smiley = {config, ...}: {
        services.miniflux = {
            enable = true;
            adminCredentialsFile = config.age.secrets.miniflux-admin.path;
            config = {
                LISTEN_ADDR = "127.0.0.1:8087";
                BASE_URL = "https://rss.calrichards.io";
            };
        };
    };
}
