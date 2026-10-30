{ config, user, ... }: {
    flake.modules.nixos.host_tarr = {
        imports = with config.flake.modules.nixos; [
            core
            dev
            gui
        ];
        hjem.users.${user.primary}.imports = [ config.flake.modules.hjem.host_tarr ];
    };
}
