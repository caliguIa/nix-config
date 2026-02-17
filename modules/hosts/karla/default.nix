{config, ...}: {
    flake.modules.nixos.host_karla.imports = with config.flake.modules.nixos; [core desktop];
}
