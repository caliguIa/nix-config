{
    flake.modules.darwin.network = let
        hostname = "polyakov";
    in {
        networking = {
            computerName = hostname;
            hostName = hostname;
            dns = ["8.8.8.8"];
            knownNetworkServices = [
                "USB 10/100/1000 LAN"
                "Thunderbolt Bridge"
                "Wi-Fi"
                "iPhone USB"
            ];
            applicationFirewall = {
                enable = true;
                blockAllIncoming = false;
                enableStealthMode = true;
            };
        };
    };

    flake.modules.nixos.network = let
        hostname = "george";
    in {
        networking = {
            useDHCP = true;
            networkmanager.enable = false;
            defaultGateway = {
                address = "192.168.0.1";
                interface = "enp1s0";
            };
            nameservers = ["8.8.8.8"];
            hostName = hostname;
            firewall = {
                enable = true;
                allowPing = true;
                trustedInterfaces = [
                    "enp1s0"
                ];
            };
            interfaces.enp1s0 = {
                ipv4.addresses = [
                    {
                        address = "192.168.0.94";
                        prefixLength = 24;
                    }
                ];
            };
        };
    };
}
