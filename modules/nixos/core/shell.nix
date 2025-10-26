{
    self,
    config,
    ...
}: let
    users = config.flake.meta.users;
in {
    flake.modules.darwin.core = {config, ...}: let
        homeDirectory = config.users.users.${users.primary}.home;
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

    flake.modules.generic.system-core-shell = {pkgs, ...}: {
        programs.fish.enable = true;
        users.users.${users.primary}.shell = pkgs.fish;
        environment = {
            shells = [pkgs.fish];
            variables = {
                EDITOR = "nvim";
            };
        };
    };
}
