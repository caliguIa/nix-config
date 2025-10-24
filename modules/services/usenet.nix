let
    user = "media";
in {
    flake.modules.nixos.usenet = {
        systemd.tmpfiles.rules = [
            "d /data/downloads 0755 root root -"
            "d /data/downloads/complete 0755 media media -"
            "d /data/downloads/complete/movies 0755 media media -"
            "d /data/downloads/complete/tv 0755 media media -"
            "d /data/downloads/complete/audiobooks 0755 media media -"
            "d /data/downloads/incomplete 0755 media media -"
        ];
        services.sabnzbd = {
            enable = true;
            openFirewall = true;
            user = user;
            group = user;
        };
        services.radarr = {
            enable = true;
            openFirewall = true;
            user = user;
            group = user;
            settings = {
                server.port = 7878;
            };
        };
        services.sonarr = {
            enable = true;
            openFirewall = true;
            user = user;
            group = user;
            settings = {
                server.port = 8989;
            };
        };
    };
}
