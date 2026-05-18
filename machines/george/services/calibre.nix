{pkgs, ...}: {
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
}
