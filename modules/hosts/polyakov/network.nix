{
    flake.modules.darwin.host_polyakov = let
        hostname = "polyakov";
    in {
        networking = {
            computerName = hostname;
            hostName = hostname;
            knownNetworkServices = [
                "USB 10/100/1000 LAN"
                "Thunderbolt Bridge"
                "Wi-Fi"
                "iPhone USB"
            ];
        };
    };
}
