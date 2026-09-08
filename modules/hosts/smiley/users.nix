{ user, ... }: {
    flake.modules.nixos.host_smiley = {
        users.users.${user.primary}.extraGroups = [
            "immich"
            "render"
            user.media
        ];
        users.users.${user.media} = {
            isSystemUser = true;
            group = user.media;
            extraGroups = [
                "render"
                "video"
            ];
        };
        users.groups.${user.media} = { };
    };
}
