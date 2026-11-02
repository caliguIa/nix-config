{
    flake.modules.nixos.host_tarr =
        { pkgs, ... }:
        let
            # Sunshine's default ports (47989 base).
            sunshinePorts = {
                allowedTCPPorts = [
                    47984
                    47989
                    47990
                    48010
                ];
                allowedUDPPorts = [
                    47998
                    47999
                    48000
                    48002
                    48010
                ];
            };
        in
        {
            services.sunshine = {
                enable = true;
                package = pkgs.sunshine.override { cudaSupport = true; };
                autoStart = true;
                capSysAdmin = true;
                settings.capture = "kms";
            };
            # The home LAN (the Shield) and the tailnet; never every interface.
            networking.firewall.interfaces = {
                eno1 = sunshinePorts;
                tailscale0 = sunshinePorts;
            };
        };
}
