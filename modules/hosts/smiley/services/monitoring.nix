{
    flake.modules.nixos.host_smiley =
        { pkgs, ... }:
        {
            # Uptime monitoring. Fronted by Caddy on the tailnet; binds
            # loopback only. State (monitors, users) lives in
            # /var/lib/uptime-kuma, backed up via backup.nix.
            services.uptime-kuma = {
                enable = true;
                settings = {
                    HOST = "127.0.0.1";
                    PORT = "3001";
                };
            };

            # Resource metrics with zero-config auto-dashboards. Single agent,
            # no separate TSDB or Grafana. Bound to loopback; Caddy fronts the
            # dashboard on the tailnet.
            #
            # The default nixpkgs build ships without the web dashboard
            # (withCloudUi = false), which makes the UI return "File does not
            # exist". Override to bundle the local agent dashboard.
            services.netdata = {
                enable = true;
                package = pkgs.netdata.override { withCloudUi = true; };
                config = {
                    global = {
                        "bind to" = "127.0.0.1:19999";
                    };
                };
            };
        };
}
