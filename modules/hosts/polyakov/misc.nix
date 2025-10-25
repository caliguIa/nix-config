{self, ...}: let
    inherit (import (self + /lib)) username;
in {
    flake.modules.darwin.host_polyakov = {
        system.defaults.screencapture.location = "/Users/${username}/Pictures/screenshots/";
    };
}
