topLevel @ {self, ...}: let
    inherit (import (self + /lib)) username;
in {
    flake.modules.darwin.desktop = {
        imports = [self.modules.generic.system-desktop-home];
    };

    flake.modules.nixos.desktop = {
        imports = [self.modules.generic.system-desktop-home];
    };

    flake.modules.generic.system-desktop-home = {
        home-manager.users.${username}.imports = [topLevel.config.flake.modules.homeManager.desktop];
    };
}
