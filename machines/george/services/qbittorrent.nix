{pkgs, ...}: {
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
}
