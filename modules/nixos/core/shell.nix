topLevel @ {...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.nixos.core = {
        config,
        pkgs,
        ...
    }: let
        homeDirectory = config.users.users.${users.primary}.home;
    in {
        programs.fish.enable = true;
        users.users.${users.primary}.shell = pkgs.fish;
        environment = {
            shells = [pkgs.fish];
            variables = {
                EDITOR = "nvim";
                XDG_CACHE_HOME = "${homeDirectory}/.cache";
                XDG_CONFIG_HOME = "${homeDirectory}/.config";
                XDG_DATA_HOME = "${homeDirectory}/.local/share";
            };
        };
    };
}
