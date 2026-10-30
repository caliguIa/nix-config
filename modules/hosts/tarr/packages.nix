{
    flake.modules.nixos.host_tarr = { pkgs, ... }: {
        services.sunshine = {
            enable = true;
            package = pkgs.sunshine.override { cudaSupport = true; };
            autoStart = true;
            capSysAdmin = true;
            settings.capture = "kms";
        };
        # Sunshine's default ports (47989 base), reachable over the tailnet only.
        networking.firewall.interfaces.tailscale0 = {
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
    };
}
