{
    flake.modules.nixos.host_karla = let
        hostname = "karla";
    in
        {pkgs, ...}: {
            environment.systemPackages = with pkgs; [networkmanagerapplet];
            networking = {
                hostName = hostname;
                networkmanager = {
                    enable = true;
                };
            };
        };
}
