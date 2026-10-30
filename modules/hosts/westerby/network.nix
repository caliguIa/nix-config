{
    flake.modules.nixos.host_westerby = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [ iwgtk ];
        networking = {
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
