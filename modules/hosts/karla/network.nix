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
                        "/george.local/192.168.0.27"
                    ];
                    no-resolv = true;
                };
            };
        };
}
