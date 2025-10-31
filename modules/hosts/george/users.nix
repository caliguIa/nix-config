topLevel @ {...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.nixos.host_george = {
        users = {
            users = {
                ${users.primary}.extraGroups = ["wheel" "networkmanager" users.media];
                ${users.media} = {
                    isSystemUser = true;
                    group = users.media;
                };
            };
            groups = {
                ${users.primary} = {};
                ${users.media} = {};
            };
        };
    };
}
