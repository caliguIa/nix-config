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
        users.defaultUserShell = pkgs.brush;
        users.users.${users.primary}.shell = pkgs.brush;
        environment = {
            shells = [pkgs.brush];
            variables = {
                EDITOR = "nvim";
                XDG_CACHE_HOME = "${homeDirectory}/.cache";
                XDG_CONFIG_HOME = "${homeDirectory}/.config";
                XDG_DATA_HOME = "${homeDirectory}/.local/share";
            };
        };
    };
}
