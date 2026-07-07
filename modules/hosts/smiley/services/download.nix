topLevel @ {...}: let
    mediaUser = topLevel.config.flake.meta.users.media;
in {
    flake.modules.nixos.host_smiley = {
        pkgs,
        config,
        ...
    }: {
        systemd.tmpfiles.rules = [
            "d /data/downloads 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete/movies 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete/tv 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete/audiobooks 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete/books 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete/comics 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete/music 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/incomplete 0755 ${mediaUser} ${mediaUser} -"
        ];
        services.sabnzbd = {
            enable = true;
            openFirewall = false;
            user = mediaUser;
            group = mediaUser;
            configFile = null;
            settings.misc = {
                host = "127.0.0.1";
                port = 8085;
            };
        };
        services.slskd = {
            enable = true;
            openFirewall = false;
            user = mediaUser;
            group = mediaUser;
            environmentFile = config.age.secrets.slskd-envars.path;
            domain = null;
            settings = {
                directories.downloads = "/data/downloads/complete/music";
                directories.incomplete = "/data/downloads/incomplete";
            };
        };
        services.qbittorrent = {
            enable = true;
            openFirewall = false;
            webuiPort = 8080;
            user = mediaUser;
            group = mediaUser;
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
