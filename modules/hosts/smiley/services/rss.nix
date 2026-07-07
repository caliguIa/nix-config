{
    flake.modules.nixos.host_smiley = {config, ...}: {
        # Miniflux RSS aggregator. Ships a responsive web UI/PWA and a
        # Google Reader-compatible sync API (enable per-user under Settings →
        # Integrations), so read state stays in sync across web and mobile
        # clients. A local PostgreSQL is provisioned automatically
        # (createDatabaseLocally defaults to true), so no database secret is
        # needed - only the initial admin credentials.
        services.miniflux = {
            enable = true;
            adminCredentialsFile = config.age.secrets.miniflux-admin.path;
            config = {
                LISTEN_ADDR = "127.0.0.1:8087";
                # Public URL served through the Cloudflare tunnel; used for
                # absolute links, the PWA manifest and integrations. The tailnet
                # host (rss.smiley.calrichards.io) also serves the UI fine.
                BASE_URL = "https://rss.calrichards.io";
            };
        };
    };
}
