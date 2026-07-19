{
    flake.modules.nixos.host_smiley = {
        pkgs,
        config,
        ...
    }: {
        services.caddy = {
            enable = true;
            package = pkgs.caddy.withPlugins {
                plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
                hash = "sha256-hEHgAG0F0ozHRAPuxEqLyTATBrE+pajeXDiSNwniorg=";
            };
            environmentFile = config.age.secrets.cloudflare-dns-token.path;
            virtualHosts."*.smiley.calrichards.io".extraConfig = ''
                tls {
                    dns cloudflare {env.CF_API_TOKEN}
                }

                @audiobooks host audiobooks.smiley.calrichards.io
                handle @audiobooks {
                    reverse_proxy localhost:8113
                }

                @music host music.smiley.calrichards.io
                handle @music {
                    reverse_proxy localhost:4533
                }

                @jellyfin host jellyfin.smiley.calrichards.io
                handle @jellyfin {
                    reverse_proxy localhost:8096
                }

                @photos host photos.smiley.calrichards.io
                handle @photos {
                    reverse_proxy localhost:2283
                }

                @books host books.smiley.calrichards.io
                handle @books {
                    reverse_proxy localhost:8083
                }

                @qbittorrent host qbittorrent.smiley.calrichards.io
                handle @qbittorrent {
                    reverse_proxy localhost:8080
                }

                @sabnzbd host sabnzbd.smiley.calrichards.io
                handle @sabnzbd {
                    reverse_proxy localhost:8085
                }

                @slsk host slsk.smiley.calrichards.io
                handle @slsk {
                    reverse_proxy localhost:5030
                }

                @stats host stats.smiley.calrichards.io
                handle @stats {
                    reverse_proxy localhost:61208
                }

                @rss host rss.smiley.calrichards.io
                handle @rss {
                    reverse_proxy localhost:8087
                }

                @ntfy host ntfy.smiley.calrichards.io
                handle @ntfy {
                    reverse_proxy localhost:2586
                }

                # Anything else on the wildcard is refused.
                handle {
                    abort
                }
            '';
        };
    };
}
