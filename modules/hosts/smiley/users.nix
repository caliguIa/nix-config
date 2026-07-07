topLevel @ {...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.nixos.host_smiley = {
        users = {
            users = {
                ${users.primary}.extraGroups = ["wheel" "networkmanager" users.media];
                ${users.media} = {
                    isSystemUser = true;
                    group = users.media;
                    # /dev/dri access for Jellyfin Intel QuickSync transcoding.
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
