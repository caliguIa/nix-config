let
    baseDomain = "george.local";
in {
    # security.acme = {
    #     acceptTerms = true;
    #     defaults.email = "acc@calrichards.io";
    #     certs.${baseDomain} = {
    #         reloadServices = ["caddy.service"];
    #         domain = "${baseDomain}";
    #         extraDomainNames = ["*.${baseDomain}"];
    #         dnsProvider = "cloudflare";
    #         dnsResolver = "1.1.1.1:53";
    #         dnsPropagationCheck = true;
    #     };
    # };
    services.caddy = {
        enable = true;
        # globalConfig = ''
        #     auto_https off
        # '';
        virtualHosts = {
            "http://${baseDomain}" = {
                extraConfig = ''
                    redir https://{host}{uri}
                '';
            };
            "http://*.${baseDomain}" = {
                extraConfig = ''
                    redir https://{host}{uri}
                '';
            };
            "media.${baseDomain}" = {
                # useACMEHost = baseDomain;
                extraConfig = ''
                    reverse_proxy http://127.0.0.1:8096
                '';
            };
            "books.${baseDomain}" = {
                # useACMEHost = baseDomain;
                extraConfig = ''
                    reverse_proxy localhost:8113
                '';
            };
            "sonarr.${baseDomain}" = {
                # useACMEHost = baseDomain;
                extraConfig = ''
                    reverse_proxy localhost:8989
                '';
            };
            "radarr.${baseDomain}" = {
                # useACMEHost = baseDomain;
                extraConfig = ''
                    reverse_proxy localhost:7878
                '';
            };
            "dl.${baseDomain}" = {
                # useACMEHost = baseDomain;
                extraConfig = ''
                    reverse_proxy localhost:8085
                '';
            };
        };
    };

    services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
            enable = true;
            addresses = true;
            domain = true;
        };
    };

    networking = {
        firewall.allowedTCPPorts = [80 443];
        firewall.allowedUDPPorts = [553];
        # hosts = {
        #     "127.0.0.1" = [
        #         "media.george.local"
        #         "books.george.local"
        #         "sonarr.george.local"
        #         "radarr.george.local"
        #         "sabnzbd.george.local"
        #     ];
        # };
    };
}
