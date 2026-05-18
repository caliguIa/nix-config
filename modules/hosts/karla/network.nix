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
                networkmanager.enable = true;
                nameservers = ["1.1.1.1" "8.8.8.8"];
                wireless.iwd = {
                    enable = false;
                    settings = {
                        General.EnableNetworkConfiguration = true;
                        DriverQuirks.DefaultInterface = true;
                        Settings.AutoConnect = true;
                        Scan.DisablePeriodicScan = false;
                        Rank.BandModifier5Ghz = 2.0;
                    };
                };
            };
        };
}
