topLevel @ {...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.nixos.host_westerby = {
        users.users.${users.primary}.extraGroups = [
            "wheel"
            "audio"
            "video"
            "realtime"
            "docker"
        ];
        users.groups.${users.primary} = {};
    };
}
