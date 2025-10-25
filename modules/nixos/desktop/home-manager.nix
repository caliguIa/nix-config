topLevel @ {self, ...}: let
    inherit (import (self + /lib)) username;
    desktopModules = topLevel.config.flake.modules.homeManager.desktop;
in {
    flake.modules.darwin.desktop = {
        home-manager.users.${username}.imports = [desktopModules];
    };

    flake.modules.nixos.desktop = {
        home-manager.users.${username}.imports = [desktopModules];
    };
}
