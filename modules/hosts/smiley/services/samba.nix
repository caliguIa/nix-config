{config, ...}: let
    users = config.flake.meta.users;
in {
    flake.modules.nixos.host_smiley = {
        systemd.tmpfiles.rules = [
            "d /data/files 0777 ${users.primary} ${users.primary} -"
            "d /data/files/documents 700 ${users.primary} ${users.primary} -"
        ];
        services.samba = {
            enable = true;
            openFirewall = false;
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
