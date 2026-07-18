{
    flake.modules.nixos.host_smiley.programs.ssh.startAgent = true;

    flake.modules.hjem.host_smiley = {
        config,
        pkgs,
        ...
    }: let
        yaml = pkgs.formats.yaml {};
    in {
        packages = [pkgs.beets];
        xdg.config.files."beets/config.yaml" = {
            generator = yaml.generate "beets-config.yaml";
            value = {
                library = "${config.directory}/.local/share/beets/library.db";
                directory = "/data/media/music";
                threaded = "yes";
                plugins = ["musicbrainz"];
                import = {
                    incremental = true;
                    move = true;
                    write = true;
                    resume = "ask";
                };
            };
        };
    };
}
