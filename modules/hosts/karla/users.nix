{user, ...}: {
    flake.modules.nixos.host_karla = {
        users.users.${user.primary}.extraGroups = [
            "wheel"
            "audio"
            "video"
            "realtime"
            "docker"
            "networkmanager"
        ];
        users.groups.${user.primary} = {};
    };
}
