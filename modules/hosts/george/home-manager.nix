{
    flake.modules.homeManager.host_george = {config, ...}: {
        services.ssh-agent.enable = true;
        programs.ssh = {
            enable = true;
            enableDefaultConfig = false;
        };
        programs.beets = {
            enable = true;
            settings = {
                library = "${config.home.homeDirectory}/.local/share/beets/library.db";
                directory = "/data/media/music";
                threaded = "yes";
                plugins = ["musicbrainz"];
                import = {
                    move = "yes";
                    write = "yes";
                    resume = "ask";
                };
            };
        };
    };
}
