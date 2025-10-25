{self, ...}: let
    inherit (import (self + /lib)) username;
in {
    flake.modules.generic.system-core-shell = {pkgs, ...}: {
        programs.fish.enable = true;
        users.users.${username}.shell = pkgs.fish;
        environment = {
            shells = [pkgs.fish];
            variables = {
                EDITOR = "nvim";
            };
        };
    };

    flake.modules.darwin.core = {config, ...}: let
        homeDirectory = config.users.users.${username}.home;
    in {
        imports = [self.modules.generic.system-core-shell];
        environment = {
            systemPath = [
                "/Applications/Docker.app/Contents/Resources/bin"
                "${homeDirectory}/.cargo/bin"
                "${homeDirectory}/.local/bin"
                "${homeDirectory}/go/bin"
            ];
            variables = {
                XDEBUG_MODE = "off";
                RAINFROG_CONFIG = "${homeDirectory}/.config/rainfrog";
            };
        };
    };

    flake.modules.nixos.core = _: {
        imports = [self.modules.generic.system-core-shell];
    };
}
