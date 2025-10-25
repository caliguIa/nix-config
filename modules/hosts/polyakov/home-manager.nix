{config, ...}: {
    flake.modules.homeManager.host_polyakov = {
        imports = with config.flake.modules.homeManager; [
            desktop
        ];
    };
}
