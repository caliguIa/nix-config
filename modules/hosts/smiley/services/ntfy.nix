{
    flake.modules.nixos.host_smiley = {
        services.ntfy-sh = {
            enable = true;
            settings = {
                # Reached over the tailnet via Caddy (see reverse-proxy.nix).
                # Access is gated by Tailscale at the network level, so ntfy
                # itself runs open (no users/tokens/ACLs).
                base-url = "https://ntfy.smiley.calrichards.io";
                listen-http = "127.0.0.1:2586";

                # Behind Caddy on loopback; extract the real client IP for
                # rate limiting from the forwarded header.
                behind-proxy = true;
            };
        };
    };
}
