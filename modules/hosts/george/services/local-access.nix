{
    flake.modules.nixos.host_george = {
        services.caddy = {
            enable = true;
            virtualHosts = {
                "http://audiobooks.george.local".extraConfig = "reverse_proxy localhost:8113";
                "http://music.george.local".extraConfig = "reverse_proxy localhost:4533";
                "http://jellyfin.george.local".extraConfig = "reverse_proxy localhost:8096";
                "http://books.george.local".extraConfig = "reverse_proxy localhost:8083";
                "http://qbittorrent.george.local".extraConfig = "reverse_proxy localhost:8080";
                "http://sabnzbd.george.local".extraConfig = "reverse_proxy localhost:8085";
                "http://slsk.george.local".extraConfig = "reverse_proxy localhost:5030";
            };
        };
        networking.firewall.allowedTCPPorts = [80];
        services.dnsmasq = {
            enable = true;
            settings = {
                address = "/.george.local/192.168.0.27";
                port = 53;
            };
        };
        networking.firewall.allowedUDPPorts = [53];
    };
}
