{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.nixos.host_george = {pkgs, ...}: {
        systemd.tmpfiles.rules = [
            "d /data 0755 root root -"
            "d /data/media 0755 root root -"
            "d /data/media/movies 0755 ${users.media} ${users.media} -"
            "d /data/media/music 0755 ${users.media} ${users.media} -"
            "d /data/media/books 0755 ${users.media} ${users.media} -"
            "d /data/media/comics 0755 ${users.media} ${users.media} -"
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
    environment.systemPackages = with pkgs; [calibre xvfb-run imagemagick];
    services.calibre-server = {
        enable = true;
        openFirewall = true;
        port = 8081;
        libraries = ["/data/media/books"];
        extraFlags = ["--enable-local-write"];
        auth = {
            enable = true;
            userDb = "/data/media/books/users.sqlite";
        };
        user = "media";
        group = "media";
    };
    services.calibre-web = {
        enable = true;
        openFirewall = true;
        options = {
            enableBookUploading = true;
            calibreLibrary = "/data/media/books";
        };
        listen = {
            ip = "0.0.0.0";
            port = 8083;
        };
        user = "media";
        group = "media";
    };
    };
}
