{
    flake.modules.nixos.host_westerby = let
        hostname = "westerby";
    in
        {pkgs, ...}: {
            environment.systemPackages = with pkgs; [iwgtk];
            networking = {
                hostName = hostname;
                wireless.enable = false;
                networkmanager.enable = false;
                wireless.iwd = {
                    enable = true;
                    settings = {
                        General.EnableNetworkConfiguration = true;
                        Settings.AutoConnect = true;
                    };
                };
            };
        };
}
