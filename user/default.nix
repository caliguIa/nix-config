{
    pkgs,
    username,
    homeDirectory,
    ...
}: {
    users = {
        users.${username} = {
            home = homeDirectory;
            shell = pkgs.fish;
        };
    };
    programs.fish.enable = true;
    environment = {
        shells = [pkgs.fish];
        systemPackages = import ../modules/packages.nix {inherit pkgs;};
        variables = {
            EDITOR = "nvim";
            XDEBUG_MODE = "off";
            RAINFROG_CONFIG = "${homeDirectory}/.config/rainfrog";
        };
    };
}
