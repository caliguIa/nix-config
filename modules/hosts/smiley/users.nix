topLevel @ {...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.nixos.host_smiley = {
        users = {
            users = {
                ${users.primary}.extraGroups = ["wheel" "networkmanager" "immich" users.media];
                ${users.media} = {
                    isSystemUser = true;
                    group = users.media;
                    extraGroups = ["render" "video"];
                };
            };
            groups = {
                ${users.primary} = {};
                ${users.media} = {};
            };
        };
    };
}
