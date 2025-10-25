{self, ...}: let
    inherit (import (self + /lib)) username;
in {
    flake.modules.darwin.host_polyakov = {config, ...}: {
        system.defaults.screencapture.location = "${config.users.users.${username}.home}/Pictures/screenshots/";
    };
}
