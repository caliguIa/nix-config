{
    flake.modules.nixos.gui = { lib, ... }: {
        systemd.services.NetworkManager-wait-online.enable = false;
        services.mullvad-vpn.enable = true;
        services.mullvad-vpn.gui.enable = true;
        # Hosts that receive transfers open the port themselves.
        programs.localsend = {
            enable = true;
            openFirewall = lib.mkDefault false;
        };

        networking = {
            networkmanager = {
                # westerby uses iwd instead.
                enable = lib.mkDefault true;
                dns = "none";
            };
            nameservers = [
                "127.0.0.1"
                "1.1.1.1"
            ];
        };

        # Mullvad enables systemd-resolved by default, which forces
        # networkmanager.dns = "systemd-resolved" and hijacks /etc/resolv.conf,
        # bypassing dnsmasq. Keep it disabled so dnsmasq handles DNS.
        services.resolved.enable = false;
        services.avahi = {
            enable = true;
            nssmdns4 = true;
        };
        services.dnsmasq = {
            enable = true;
            settings = {
                address = [ "/local.oneupsales.dev/127.0.0.3" ];
                server = [
                    "/ts.net/100.100.100.100"
                    "1.1.1.1"
                    "8.8.8.8"
                ];
                no-resolv = true;
            };
        };
    };
}
