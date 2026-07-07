{
    flake.modules.nixos.host_smiley = {
        services.glances = {
            enable = true;
            port = 61208;
            openFirewall = false;
            extraArgs = ["--webserver" "--bind" "127.0.0.1"];
        };
    };
}
