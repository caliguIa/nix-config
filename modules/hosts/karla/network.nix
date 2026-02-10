{
    flake.modules.nixos.host_karla = let
        hostname = "karla";
    in
        {pkgs, ...}: {
            environment.systemPackages = with pkgs; [iwgtk];
            networking = {
                hostName = hostname;
                networkmanager.enable = false;
                wireless.enable = false;
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
