{pkgs, ...}: {
    services.minecraft-servers = {
        enable = true;
        eula = true;
        openFirewall = true;
        servers = {
            cool-server = {
                enable = true;
                package = pkgs.paperServers.paper-1_21_10;
                serverProperties = {
                    difficulty = 3;
                    server-port = 25566;
                    gamemode = 0;
                    max-players = 4;
                    motd = "cal's serious server";
                    simulation-distance = 4;
                    view-distance = 7;
                    network-compression-threshold = 256;
                };
            };
        };
    };
}
