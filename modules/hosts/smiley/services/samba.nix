{user, ...}: {
    flake.modules.nixos.host_smiley = {
        systemd.tmpfiles.rules = [
            "d /data/files 0777 ${user.primary} ${user.primary} -"
            "d /data/files/documents 700 ${user.primary} ${user.primary} -"
        ];
        services.samba = {
            enable = true;
            openFirewall = false;
            settings.data = {
                "path" = "/data";
                "valid users" = [user.primary user.media];
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
