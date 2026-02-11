{
    flake.modules.nixos.host_karla = let
        hostname = "karla";
    in
        {pkgs, ...}: {
            environment.systemPackages = with pkgs; [iwgtk];
            networking = {
                hostName = hostname;
                wireless.enable = false;
                networkmanager.enable = false;
                dhcpcd.enable = false;
                nameservers = ["1.1.1.1" "8.8.8.8"];
                wireless.iwd = {
                    enable = true;
                    settings = {
                        General.EnableNetworkConfiguration = true;
                        DriverQuirks.DefaultInterface = true;
                        Settings.AutoConnect = true;
                        Scan.DisablePeriodicScan = false;
                        Rank.BandModifier5Ghz = 2.0;
                    };
                };
            };
            services.resolved.enable = true;
        };
}
