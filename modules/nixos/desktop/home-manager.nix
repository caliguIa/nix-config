{
    config,
    self,
    ...
}: let
    users = config.flake.meta.users;
in {
    flake.modules.darwin.desktop = {
        imports = [self.modules.generic.system-desktop-home];
    };

    flake.modules.nixos.desktop = {
        imports = [self.modules.generic.system-desktop-home];
    };

    flake.modules.generic.system-desktop-home = {
        home-manager.users.${users.primary}.imports = [config.flake.modules.homeManager.desktop];
    };
}
