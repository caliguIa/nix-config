{self, ...}: let
    inherit (import (self + /lib)) username mediaUser;
in {
    flake.modules.nixos.users = {
        users = {
            users = {
                ${username}.extraGroups = ["wheel" "networkmanager" mediaUser];
                ${mediaUser} = {
                    isSystemUser = true;
                    group = mediaUser;
                };
            };
            groups = {
                ${username} = {};
                ${mediaUser} = {};
            };
        };
    };
}
