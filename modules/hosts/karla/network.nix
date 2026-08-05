{
  flake.modules.nixos.host_karla =
    let
      hostname = "karla";
    in
    {
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
        networkmanager = {
          enable = true;
          dns = "none";
        };
        nameservers = [
          "127.0.0.1"
          "1.1.1.1"
        ];
      };
      # Mullvad enables systemd-resolved by default, which forces
      # networkmanager.dns = "systemd-resolved" and hijacks /etc/resolv.conf,
      # bypassing dnsmasq. Keep it disabled so dnsmasq handles DNS.
      services.resolved.enable = false;
      services.avahi = {
        enable = true;
        nssmdns4 = true;
      };
      services.dnsmasq = {
        enable = true;
        settings = {
          address = [ "/local.oneupsales.dev/127.0.0.3" ];
          server = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          no-resolv = true;
        };
      };
      services.tailscale = {
        enable = true;
        openFirewall = true;
      };
    };
}
