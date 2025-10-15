{
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
}
