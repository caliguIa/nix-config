{
    flake.modules.nixos.host_karla = let
        hostname = "karla";
    in
        {pkgs, ...}: {
            environment.systemPackages = with pkgs; [iwgtk];
            networking = {
                hostName = hostname;
                firewall = {
                    allowedTCPPortRanges = [
                        {
                            from = 1714;
                            to = 1764;
                        }
                    ];
                    allowedUDPPortRanges = [
                        {
                            from = 1714;
                            to = 1764;
                        }
                    ];
                };
                wireless.enable = true;
                networkmanager = {
                    enable = true;
                    dns = "none";
                };
                nameservers = ["127.0.0.1" "1.1.1.1"];
                wireless.iwd.enable = false;
            };
            services.avahi = {
                enable = true;
                nssmdns4 = true;
            };
            services.dnsmasq = {
                enable = true;
                settings = {
                    address = ["/local.oneupsales.dev/127.0.0.3"];
                    server = [
                        "1.1.1.1"
                        "8.8.8.8"
                    ];
                    no-resolv = true;
                };
            };
            # Tailscale for reaching smiley (SSH/SMB/admin UIs) over the tailnet.
            # Bring up with `sudo tailscale up --accept-dns=false` so tailscaled
            # leaves karla's dnsmasq/resolv.conf setup alone (we use public DNS
            # for *.smiley.calrichards.io, not MagicDNS).
            services.tailscale = {
                enable = true;
                openFirewall = true;
            };
        };
}
