{config, ...}: {
    flake.modules.nixos.host_smiley.imports = with config.flake.modules.nixos; [core];
}
