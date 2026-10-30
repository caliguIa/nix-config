{ config, user, ... }: {
    flake.modules.nixos.host_karla = {
        imports = with config.flake.modules.nixos; [
            core
            dev
            gaming
            gui
            laptop
        ];
        hjem.users.${user.primary}.imports = [ config.flake.modules.hjem.host_karla ];
    };
}
