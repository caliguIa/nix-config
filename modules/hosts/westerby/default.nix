{config, ...}: {
    flake.modules.nixos.host_westerby.imports = with config.flake.modules.nixos; [desktop];
}
