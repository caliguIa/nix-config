{
    flake.modules.nixos.host_george = let
        hostname = "george";
    in {
        networking = {
            useDHCP = true;
            defaultGateway = {
                address = "192.168.0.1";
                interface = "enp1s0";
            };
            hostName = hostname;
            firewall.trustedInterfaces = ["enp1s0"];
        };
    };
}
