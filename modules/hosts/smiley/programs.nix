{
    # ssh-agent, previously home-manager's services.ssh-agent, is now provided
    # by the system. programs.ssh (enableDefaultConfig=false, no hosts) only
    # produced an empty ~/.ssh/config under home-manager, so it is dropped.
    flake.modules.nixos.host_smiley.programs.ssh.startAgent = true;

    flake.modules.hjem.host_smiley = {pkgs, ...}: {
        packages = [pkgs.beets];
        xdg.config.files."beets/config.yaml".source =
            (pkgs.formats.yaml {}).generate "beets-config.yaml" {
                library = "/home/caligula/.local/share/beets/library.db";
                directory = "/data/media/music";
                threaded = "yes";
                plugins = ["musicbrainz"];
                import = {
                    incremental = "yes";
                    move = "yes";
                    write = "yes";
                    resume = "ask";
                };
            };
    };
}
