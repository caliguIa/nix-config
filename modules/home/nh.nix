{
    flake.modules.homeManager.nh = {config, ...}: {
        programs.nh = {
            enable = true;
            clean.enable = true;
            clean.extraArgs = "--keep-since 4d --keep 2";
            flake = "${config.home.homeDirectory}/nix-config";
        };
    };
}
