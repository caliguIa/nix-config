{ user, ... }: {
    flake.modules.nixos.host_smiley = {
        users = {
            users = {
                ${user.primary}.extraGroups = [
                    "wheel"
                    "networkmanager"
                    "immich"
                    "render"
                    "video"
                    user.media
                ];
                ${user.media} = {
                    isSystemUser = true;
                    group = user.media;
                    extraGroups = [
                        "render"
                        "video"
                    ];
                };
            };
            groups = {
                ${user.primary} = { };
                ${user.media} = { };
            };
        };
    };
}
