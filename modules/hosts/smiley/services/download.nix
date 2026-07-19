{
    flake.modules.nixos.host_smiley = {
        pkgs,
        lib,
        config,
        mediaService,
        mediaDir,
        slskdImport,
        ...
    }: {
        systemd.tmpfiles.rules = map mediaDir [
            "/data/downloads"
            "/data/downloads/complete"
            "/data/downloads/complete/movies"
            "/data/downloads/complete/tv"
            "/data/downloads/complete/audiobooks"
            "/data/downloads/complete/books"
            "/data/downloads/complete/comics"
            "/data/downloads/complete/music"
            "/data/downloads/incomplete"
        ];
        services.sabnzbd = mediaService {
            # configFile defaults to a mutable ini on stateVersion < 26.05, which
            # makes `settings` be ignored. null lets `settings` take effect.
            configFile = null;
            settings.misc = {
                host = "127.0.0.1";
                port = 8085;
            };
        };
        services.slskd = mediaService {
            environmentFile = config.age.secrets.slskd-envars.path;
            domain = null;
            settings = {
                directories.downloads = "/data/downloads/complete/music";
                directories.incomplete = "/data/downloads/incomplete";
                # Auto-import each completed album into beets. slskd runs as the
                # media user, so the hook (which imports + cleans up) runs with
                # correct ownership without sudo. Fires once per album via the
                # DownloadDirectoryComplete event (not per track).
                # NOTE: slskd 0.24.5 uses the singular top-level key
                # "integration" (plural "integrations" in newer docs is silently
                # ignored by the YAML parser).
                integration.scripts.beets-import = {
                    on = ["DownloadDirectoryComplete"];
                    run.executable = lib.getExe slskdImport;
                };
            };
        };

        # The slskd systemd sandbox (ProtectSystem=strict) makes the whole FS
        # read-only except its ReadWritePaths. The beets-import hook runs as a
        # child of slskd inside this sandbox, so it needs write access to the
        # beets state dir and the music library it imports into.
        systemd.services.slskd.serviceConfig.ReadWritePaths = [
            "/var/lib/beets"
            "/data/media/music"
        ];
        services.qbittorrent = mediaService {
            webuiPort = 8080;
            serverConfig = {
                LegalNotice.Accepted = true;
                Preferences = {
                    General.Locale = "en";
                    IPFilter.BannedIPs = "";
                    WebUI = {
                        Address = "127.0.0.1";
                        Username = "admin";
                        Password_PBKDF2 = "@ByteArray(+1ZSiSWMaiWPiLNWIHNcug==:usRLXuCrx/sxOTZ+SiM9qvT32DSVxGQWbu2pZZrOI4Fi2PXFjF6PjzoBridfI70z/CqPt9XS7ERMcould3DCMw==)";
                        AlternativeUIEnabled = true;
                        RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
                        BanDuration = 10;
                    };
                };
            };
        };
    };
}
