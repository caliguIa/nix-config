topLevel @ {...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.nixos.host_westerby = {
        users.users.${users.primary}.extraGroups = [
            "wheel"
            "networkmanager"
            "audio"
            "video"
            "realtime"
        ];
        users.groups.${users.primary} = {};
    };
}
