let
    user = "media";
in {
    flake.modules.nixos.host_george = {
        systemd.tmpfiles.rules = [
            "d /data/media 0755 root root -"
            "d /data/media/movies 0755 media media -"
            "d /data/media/tv 0755 media media -"
            "d /data/media/audiobooks 0755 media media -"
        ];
        services.audiobookshelf = {
            enable = true;
            port = 8113;
            host = "0.0.0.0";
            user = user;
            group = user;
        };
        services.jellyfin = {
            enable = true;
            openFirewall = true;
            user = user;
            group = user;
        };
        services.samba = {
            enable = true;
            settings = {
                "audiobooks" = {
                    "path" = "/data/media/audiobooks";
                    "valid users" = ["caligula" "media"];
                    "fruit:aapl" = "yes";
                    "browseable" = "yes";
                    "writeable" = "yes";
                    "guest ok" = "yes";
                    "read only" = "no";
                    "vfs objects" = "catia fruit streams_xattr";
                };
                "movies" = {
                    "path" = "/data/media/movies";
                    "valid users" = ["caligula" "media"];
                    "fruit:aapl" = "yes";
                    "browseable" = "yes";
                    "writeable" = "yes";
                    "guest ok" = "yes";
                    "read only" = "no";
                    "vfs objects" = "catia fruit streams_xattr";
                };
                "tv" = {
                    "path" = "/data/media/tv";
                    "valid users" = ["caligula" "media"];
                    "fruit:aapl" = "yes";
                    "browseable" = "yes";
                    "writeable" = "yes";
                    "guest ok" = "yes";
                    "read only" = "no";
                    "vfs objects" = "catia fruit streams_xattr";
                };
            };
        };
    };
}
