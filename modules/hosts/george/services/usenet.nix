{config, ...}: let
    mediaUser = config.flake.meta.users.media;
in {
    flake.modules.nixos.host_george = {
        systemd.tmpfiles.rules = [
            "d /data/downloads 0755 root root -"
            "d /data/downloads/complete 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete/movies 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete/tv 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/complete/audiobooks 0755 ${mediaUser} ${mediaUser} -"
            "d /data/downloads/incomplete 0755 ${mediaUser} ${mediaUser} -"
        ];
        services.sabnzbd = {
            enable = true;
            openFirewall = true;
            user = mediaUser;
            group = mediaUser;
        };
        services.radarr = {
            enable = true;
            openFirewall = true;
            user = mediaUser;
            group = mediaUser;
            settings = {
                server.port = 7878;
            };
        };
        services.sonarr = {
            enable = true;
            openFirewall = true;
            user = mediaUser;
            group = mediaUser;
            settings = {
                server.port = 8989;
            };
        };
    };
}
