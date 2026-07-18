{
    flake.modules.nixos.host_smiley = {
        pkgs,
        mediaService,
        mediaDir,
        ...
    }: {
        systemd.tmpfiles.rules = map mediaDir [
            "/data"
            "/data/media"
            "/data/media/movies"
            "/data/media/music"
            "/data/media/books"
            "/data/media/comics"
            "/data/media/tv"
            "/data/media/audiobooks"
        ];

        services.navidrome = mediaService {
            settings = {
                Address = "127.0.0.1";
                Port = 4533;
                MusicFolder = "/data/media/music";
            };
        };
        services.audiobookshelf = mediaService {
            port = 8113;
            host = "127.0.0.1";
        };
        services.jellyfin = mediaService {};
        services.calibre-server = mediaService {
            port = 8081;
            libraries = ["/data/media/books"];
            extraFlags = ["--enable-local-write" "--listen-on=127.0.0.1"];
            auth = {
                enable = true;
                userDb = "/data/media/books/users.sqlite";
            };
        };
        services.calibre-web = mediaService {
            enable = false;
            options = {
                enableBookUploading = true;
                calibreLibrary = "/data/media/books";
            };
            listen = {
                ip = "127.0.0.1";
                port = 8083;
            };
        };
        environment.systemPackages = with pkgs; [calibre xvfb-run imagemagick];

        # Intel QuickSync / VAAPI for Jellyfin hardware transcoding. After
        # deploying, enable "Intel QuickSync (QSV)" under Jellyfin → Dashboard →
        # Playback → Transcoding (the media user is in render/video for /dev/dri).
        hardware.graphics = {
            enable = true;
            extraPackages = with pkgs; [
                intel-media-driver
                intel-compute-runtime
            ];
        };
    };
}
