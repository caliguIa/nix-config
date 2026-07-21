{
    flake.modules.nixos.host_smiley = let
        hostname = "smiley";
    in {
        networking = {
            hostName = hostname;
            useDHCP = true;
            defaultGateway = {
                address = "192.168.0.1";
                interface = "enp1s0";
            };
            # Full lockdown: no trustedInterfaces. Every port is explicit and
            # scoped to the interface that legitimately needs it.
            firewall = {
                enable = true;
                interfaces = {
                    # LAN: only file sharing (SMB), SSH and mDNS discovery.
                    enp1s0 = {
                        allowedTCPPorts = [22 445];
                        allowedUDPPorts = [5353];
                    };
                    # Tailnet: the caddy reverse proxy (80/443), SSH and SMB.
                    tailscale0 = {
                        allowedTCPPorts = [22 80 443 445];
                        allowedUDPPorts = [5353];
                    };
                };
            };
        };
        programs.ssh.startAgent = true;
        services.tailscale = {
            enable = true;
            openFirewall = true;
        };
    };
}
