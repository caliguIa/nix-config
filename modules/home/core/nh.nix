{
    flake.modules.homeManager.core = {config, ...}: {
        programs.nh = {
            enable = true;
            flake = "${config.home.homeDirectory}/nix-config";
            clean = {
                enable = true;
                dates = "daily";
                extraArgs = "--keep-since 4d --keep 2";
            };
        };
    };
}
