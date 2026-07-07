{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.nixos.host_smiley = {pkgs, ...}: {
        systemd.tmpfiles.rules = [
            "d /data 0755 ${users.media} ${users.media} -"
            "d /data/media 0755 ${users.media} ${users.media} -"
            "d /data/media/movies 0755 ${users.media} ${users.media} -"
            "d /data/media/music 0755 ${users.media} ${users.media} -"
            "d /data/media/books 0755 ${users.media} ${users.media} -"
            "d /data/media/comics 0755 ${users.media} ${users.media} -"
            "d /data/media/tv 0755 ${users.media} ${users.media} -"
            "d /data/media/audiobooks 0755 ${users.media} ${users.media} -"
        ];

        services.navidrome = {
            enable = true;
            user = users.media;
            group = users.media;
            openFirewall = false;
            settings = {
                Address = "127.0.0.1";
                Port = 4533;
                MusicFolder = "/data/media/music";
            };
        };
        services.audiobookshelf = {
            enable = true;
            port = 8113;
            host = "127.0.0.1";
            openFirewall = false;
            user = users.media;
            group = users.media;
        };
        services.jellyfin = {
            enable = true;
            openFirewall = false;
            user = users.media;
            group = users.media;
        };
        services.calibre-server = {
            enable = true;
            openFirewall = false;
            port = 8081;
            libraries = ["/data/media/books"];
            extraFlags = ["--enable-local-write" "--listen-on=127.0.0.1"];
            auth = {
                enable = true;
                userDb = "/data/media/books/users.sqlite";
            };
            user = users.media;
            group = users.media;
        };
        services.calibre-web = {
            enable = true;
            openFirewall = false;
            options = {
                enableBookUploading = true;
                calibreLibrary = "/data/media/books";
            };
            listen = {
                ip = "127.0.0.1";
                port = 8083;
            };
            user = users.media;
            group = users.media;
        };
        environment.systemPackages = with pkgs; [calibre xvfb-run imagemagick];
        hardware.graphics = {
            enable = true;
            extraPackages = with pkgs; [
                intel-media-driver
                intel-compute-runtime
            ];
        };
    };
}
