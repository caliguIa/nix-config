{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.nixos.host_george = {
        systemd.tmpfiles.rules = [
            "d /data/media 0755 root root -"
            "d /data/media/movies 0755 ${users.media} ${users.media} -"
            "d /data/media/tv 0755 ${users.media} ${users.media} -"
            "d /data/media/audiobooks 0755 ${users.media} ${users.media} -"
        ];
        services.audiobookshelf = {
            enable = true;
            port = 8113;
            host = "0.0.0.0";
            user = users.media;
            group = users.media;
        };
        services.jellyfin = {
            enable = true;
            openFirewall = true;
            user = users.media;
            group = users.media;
        };
        services.samba = {
            enable = true;
            settings = {
                "audiobooks" = {
                    "path" = "/data/media/audiobooks";
                    "valid users" = [users.primary users.media];
                    "fruit:aapl" = "yes";
                    "browseable" = "yes";
                    "writeable" = "yes";
                    "guest ok" = "yes";
                    "read only" = "no";
                    "vfs objects" = "catia fruit streams_xattr";
                };
                "movies" = {
                    "path" = "/data/media/movies";
                    "valid users" = [users.primary users.media];
                    "fruit:aapl" = "yes";
                    "browseable" = "yes";
                    "writeable" = "yes";
                    "guest ok" = "yes";
                    "read only" = "no";
                    "vfs objects" = "catia fruit streams_xattr";
                };
                "tv" = {
                    "path" = "/data/media/tv";
                    "valid users" = [users.primary users.media];
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
