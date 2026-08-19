{
    flake.modules.nixos.host_smiley =
        { ... }:
        {
            # Landing page for all self-hosted services. Fronted by Caddy on
            # the tailnet; binds loopback only. Config is declarative here, so
            # nothing to back up.
            services.homepage-dashboard = {
                enable = true;
                listenPort = 8082;
                # Homepage rejects requests whose Host header is not allowlisted.
                # Caddy forwards the external host, so allow it plus loopback.
                allowedHosts = "home.smiley.calrichards.io,localhost:8082,127.0.0.1:8082";

                settings = {
                    title = "smiley";
                    headerStyle = "clean";
                };

                services = [
                    {
                        Media = [
                            { Jellyfin.href = "https://jellyfin.smiley.calrichards.io"; }
                            { Navidrome.href = "https://music.smiley.calrichards.io"; }
                            { Audiobookshelf.href = "https://audiobooks.smiley.calrichards.io"; }
                            { "Calibre-web".href = "https://books.smiley.calrichards.io"; }
                            { Immich.href = "https://photos.smiley.calrichards.io"; }
                        ];
                    }
                    {
                        Downloads = [
                            { qBittorrent.href = "https://qbittorrent.smiley.calrichards.io"; }
                            { SABnzbd.href = "https://sabnzbd.smiley.calrichards.io"; }
                            { slskd.href = "https://slsk.smiley.calrichards.io"; }
                        ];
                    }
                    {
                        Productivity = [
                            { Miniflux.href = "https://rss.smiley.calrichards.io"; }
                            { Karakeep.href = "https://bookmarks.smiley.calrichards.io"; }
                            { Forgejo.href = "https://git.calrichards.io"; }
                            { ntfy.href = "https://ntfy.smiley.calrichards.io"; }
                        ];
                    }
                    {
                        Monitoring = [
                            { "Uptime Kuma".href = "https://uptime.smiley.calrichards.io"; }
                            { Netdata.href = "https://metrics.smiley.calrichards.io"; }
                        ];
                    }
                ];

                widgets = [
                    {
                        resources = {
                            cpu = true;
                            memory = true;
                            disk = "/";
                        };
                    }
                    {
                        search = {
                            provider = "duckduckgo";
                            target = "_blank";
                        };
                    }
                ];
            };
        };
}
