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
                integration.scripts.beets-import = {
                    on = ["DownloadDirectoryComplete"];
                    run.executable = lib.getExe slskdImport;
                };
            };
        };
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
