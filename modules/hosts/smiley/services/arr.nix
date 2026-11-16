{
    flake.modules.nixos.host_smiley =
        {
            lib,
            mediaService,
            ...
        }:
        {
            # *arr stack: Prowlarr (indexers) -> Sonarr (tv) / Radarr (movies)
            # -> SABnzbd / qBittorrent, with Seerr as the request front-end
            # for Jellyfin users. All bind loopback only and are fronted by
            # Caddy on the tailnet; nothing opens a firewall port.
            #
            # Sonarr/Radarr run as the media user so they can hardlink/move
            # completed downloads from /data/downloads into /data/media.
            # They use their own download-client categories ("sonarr" /
            # "radarr", see download.nix) so the SABnzbd post-process script
            # never moves a job out from under them.
            #
            # First-run setup (API keys, auth, download clients, root folders
            # /data/media/tv and /data/media/movies) is done in each web UI;
            # state lives in /var/lib and is deliberately not backed up.

            services.prowlarr = {
                enable = true;
                openFirewall = false;
                # No in-app login: reachable only via Caddy on the tailnet.
                settings.auth.method = "External";
                settings.server = {
                    bindaddress = "127.0.0.1";
                    port = 9696;
                };
            };

            services.sonarr = mediaService {
                # No in-app login: reachable only via Caddy on the tailnet.
                settings.auth.method = "External";
                settings.server = {
                    bindaddress = "127.0.0.1";
                    port = 8989;
                };
            };

            services.radarr = mediaService {
                # No in-app login: reachable only via Caddy on the tailnet.
                settings.auth.method = "External";
                settings.server = {
                    bindaddress = "127.0.0.1";
                    port = 7878;
                };
            };

            services.seerr = {
                enable = true;
                openFirewall = false;
                port = 5055;
                # Fresh install: use the new /var/lib/seerr location rather
                # than the legacy jellyseerr path implied by stateVersion 24.11.
                stateRevision = 1;
            };
            # Seerr listens on all interfaces unless HOST is set.
            systemd.services.seerr.environment.HOST = "127.0.0.1";

            # Sonarr/Radarr write imported files group-writable so the rest of
            # the media stack (and the primary user) can manage them.
            systemd.services.sonarr.serviceConfig.UMask = lib.mkForce "0002";
            systemd.services.radarr.serviceConfig.UMask = lib.mkForce "0002";
        };
}
