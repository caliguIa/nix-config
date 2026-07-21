{
    flake.modules.nixos.host_smiley = {config, ...}: {
        services.immich = {
            enable = true;
            host = "127.0.0.1";
            port = 2283;

            mediaLocation = "/data/photos";

            accelerationDevices = ["/dev/dri/renderD128"];

            settings = {
                newVersionCheck.enabled = false;
                server.externalDomain = "https://photos.calrichards.io";
            };
        };

        users.users.immich.extraGroups = ["render" "video"];

        systemd.tmpfiles.rules = [
            "d /data/photos 0700 ${config.services.immich.user} ${config.services.immich.group} -"
        ];
    };
}
