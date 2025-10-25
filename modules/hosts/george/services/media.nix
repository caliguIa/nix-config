{self, ...}: let
    inherit (import (self + /lib)) username mediaUser;
in {
    flake.modules.nixos.host_george = {
        systemd.tmpfiles.rules = [
            "d /data/media 0755 root root -"
            "d /data/media/movies 0755 ${mediaUser} ${mediaUser} -"
            "d /data/media/tv 0755 ${mediaUser} ${mediaUser} -"
            "d /data/media/audiobooks 0755 ${mediaUser} ${mediaUser} -"
        ];
        services.audiobookshelf = {
            enable = true;
            port = 8113;
            host = "0.0.0.0";
            user = mediaUser;
            group = mediaUser;
        };
        services.jellyfin = {
            enable = true;
            openFirewall = true;
            user = mediaUser;
            group = mediaUser;
        };
        services.samba = {
            enable = true;
            settings = {
                "audiobooks" = {
                    "path" = "/data/media/audiobooks";
                    "valid users" = [username mediaUser];
                    "fruit:aapl" = "yes";
                    "browseable" = "yes";
                    "writeable" = "yes";
                    "guest ok" = "yes";
                    "read only" = "no";
                    "vfs objects" = "catia fruit streams_xattr";
                };
                "movies" = {
                    "path" = "/data/media/movies";
                    "valid users" = [username mediaUser];
                    "fruit:aapl" = "yes";
                    "browseable" = "yes";
                    "writeable" = "yes";
                    "guest ok" = "yes";
                    "read only" = "no";
                    "vfs objects" = "catia fruit streams_xattr";
                };
                "tv" = {
                    "path" = "/data/media/tv";
                    "valid users" = [username mediaUser];
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
