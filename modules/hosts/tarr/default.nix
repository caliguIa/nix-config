{ config, ... }: {
    flake.modules.nixos.host_tarr.imports = with config.flake.modules.nixos; [
        core
        gui
    ];
}
