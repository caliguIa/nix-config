{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.nixos.host_george = {
        services.samba = {
            enable = true;
            openFirewall = true;
            settings.data = {
                "path" = "/data";
                "valid users" = [users.primary users.media];
                "fruit:aapl" = "true";
                "browseable" = "true";
                "writeable" = "true";
                "guest ok" = "false";
                "read only" = "false";
                "vfs objects" = "catia fruit streams_xattr";
            };
        };
        services.avahi = {
            enable = true;
            openFirewall = true;
            nssmdns4 = true;
            publish = {
                enable = true;
                addresses = true;
                userServices = true;
            };
        };
    };
}
