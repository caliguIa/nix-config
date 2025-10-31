{
    flake.modules.nixos.host_westerby = let
        hostname = "westerby";
    in {
        networking = {
            networkmanager.enable = true;
            hostName = hostname;
            wireless.iwd = {
                enable = true;
                settings.General.EnableNetworkConfiguration = true;
            };
        };
    };
}
