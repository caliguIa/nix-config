{
    flake.modules.nixos.host_smiley = {config, ...}: {
        # Immich: self-hosted photo/video library with phone auto-backup, face
        # recognition and object/CLIP search. Runs as its own `immich` system
        # user (not the shared media user) because the module wants a private
        # 0700 media dir it fully owns.
        #
        # The module provisions everything else automatically:
        #   - a database on the local PostgreSQL (shared with miniflux), adding
        #     the pgvector/vectorchord extensions it needs, over a unix socket
        #     so no DB password/secret is required;
        #   - a dedicated Redis instance on a unix socket;
        #   - the immich-machine-learning service for faces/search.
        services.immich = {
            enable = true;
            host = "127.0.0.1"; # LAN-private; reached only via caddy/cloudflared
            port = 2283;

            # Photos live on the data disk alongside the rest of the media, not
            # the default /var/lib/immich. A non-default location must be created
            # by us with the immich user owning it (see tmpfiles rule below).
            mediaLocation = "/data/photos";

            # Intel QuickSync / VAAPI is already set up for Jellyfin in
            # media.nix. Grant immich the render node so hardware transcoding and
            # ML acceleration can be turned on in Admin -> Settings.
            accelerationDevices = ["/dev/dri/renderD128"];

            settings = {
                newVersionCheck.enabled = false;
                # Absolute base for publicly shared links / the mobile app,
                # served through the Cloudflare tunnel.
                server.externalDomain = "https://photos.calrichards.io";
            };
        };

        # immich runs as its own user; add it to the GPU groups so it can open
        # /dev/dri/renderD128 for hardware acceleration.
        users.users.immich.extraGroups = ["render" "video"];

        # Create the non-default media dir owned by immich (0700, as the module
        # expects). `d` creates it if missing without clobbering existing perms.
        systemd.tmpfiles.rules = [
            "d /data/photos 0700 ${config.services.immich.user} ${config.services.immich.group} -"
        ];
    };
}
