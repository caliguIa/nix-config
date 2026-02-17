{config, ...}: {
    flake.modules.nixos.host_george.imports = with config.flake.modules.nixos; [core];
}
