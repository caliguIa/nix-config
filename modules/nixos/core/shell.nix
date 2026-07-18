{user, ...}: {
    flake.modules.nixos.core = {
        config,
        pkgs,
        ...
    }: let
        homeDirectory = config.users.users.${user.primary}.home;
    in {
        programs.fish.enable = true;
        users.defaultUserShell = pkgs.fish;
        users.users.${user.primary}.shell = pkgs.fish;
        environment = {
            shells = [pkgs.fish];
            variables = {
                EDITOR = "nvim";
                XDG_CACHE_HOME = "${homeDirectory}/.cache";
                XDG_CONFIG_HOME = "${homeDirectory}/.config";
                XDG_DATA_HOME = "${homeDirectory}/.local/share";
            };
            systemPackages = [pkgs.ghostty.terminfo];
        };
    };
}
