let
    username = "caligula";
in {
    flake.modules.darwin.core = {pkgs, ...}: let
        homeDirectory = "/Users/${username}";
    in {
        programs.fish.enable = true;
        users.users.${username}.shell = pkgs.fish;
        environment = {
            shells = [pkgs.fish];
            systemPath = [
                "/Applications/Docker.app/Contents/Resources/bin"
                "${homeDirectory}/.cargo/bin"
                "${homeDirectory}/.local/bin"
                "${homeDirectory}/go/bin"
            ];
            variables = {
                EDITOR = "nvim";
                XDEBUG_MODE = "off";
                RAINFROG_CONFIG = "${homeDirectory}/.config/rainfrog";
            };
        };
    };

    flake.modules.nixos.core = {pkgs, ...}: {
        programs.fish.enable = true;
        users.users.${username}.shell = pkgs.fish;
        environment = {
            shells = [pkgs.fish];
            variables = {
                EDITOR = "nvim";
            };
        };
    };
}
