{config, ...}: {
    flake.modules.darwin.host_polyakov.imports = with config.flake.modules.darwin; [
        desktop
    ];
}
