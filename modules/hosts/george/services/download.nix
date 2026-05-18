{config, ...}: let
    mediaUser = config.flake.meta.users.media;
in {
    flake.modules.nixos.host_george = {pkgs, ...}: {
        systemd.tmpfiles.rules = [
            "d /data/downloads 0755 root root -"
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
            openFirewall = true;
            user = mediaUser;
            group = mediaUser;
        };
       services.qbittorrent = {
        enable = true;
        openFirewall = true;
        webuiPort = 8080;
        user = "media";
        group = "media";
        serverConfig = {
            LegalNotice.Accepted = true;
            Preferences = {
                General.Locale = "en";
                IPFilter.BannedIPs = "";
                WebUI = {
                    Username = "admin";
                    Password_PBKDF2 = "@ByteArray(ARQ77eY1NUZaQsuDHbIMCA==:0WMRkYTUWVT9wVvdDtHAjU9b3b7uB8NR1Gur2hmQCvCDpm39Q+PsJRJPaCU51dEiz+dTzh8qbPsL8WkFljQYFQ==)";
                    AlternativeUIEnabled = true;
                    RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
                    BanDuration = 10;
                };
            };
        };
    };
    };
}
