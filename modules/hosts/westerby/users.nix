{user, ...}: {
    flake.modules.nixos.host_westerby = {
        users.users.${user.primary}.extraGroups = [
            "wheel"
            "audio"
            "video"
            "realtime"
            "docker"
        ];
        users.groups.${user.primary} = {};
    };
}
