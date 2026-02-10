topLevel @ {...}: let
    users = topLevel.config.flake.meta.users;
in {
    flake.modules.nixos.host_karla = {
        users.users.${users.primary}.extraGroups = [
            "wheel"
            "audio"
            "video"
            "realtime"
            "docker"
            "networkmanager"
        ];
        users.groups.${users.primary} = {};
    };
}
