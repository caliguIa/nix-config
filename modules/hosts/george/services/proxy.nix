{
    flake.modules.nixos.host_george = {
        config,
        pkgs,
        ...
    }: {
        environment.systemPackages = [pkgs.cloudflared];
        services.cloudflared = {
            enable = true;
            tunnels = {
                "4ea6e900-1983-443e-82bc-a7607fecd5e4" = {
                    credentialsFile = "${config.age.secrets.cloudflared-audiobookshelf.path}";
                    default = "http_status:404";
                };
                "18d2d25e-2e47-4706-86c8-016fcb7c59c5" = {
                    credentialsFile = "${config.age.secrets.cloudflared-navidrome.path}";
                    default = "http_status:404";
                };
                "f9431d96-b817-4aee-bbc0-e910ec77a4a0" = {
                    credentialsFile = "${config.age.secrets.cloudflared-slskd.path}";
                    default = "http_status:404";
                };
            };
        };
    };
}
