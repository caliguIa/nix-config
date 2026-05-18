{
    flake.modules.nixos.host_george = {
    services.samba = {
        enable = true;
        openFirewall = true;
        shares.data = {
            "path" = "/data";
            "valid users" = ["caligula" "media"];
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
            userServices = true;
        };
    };
    };
}
