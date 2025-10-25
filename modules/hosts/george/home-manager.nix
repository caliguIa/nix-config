{config, ...}: {
    flake.modules.homeManager.host_george = {
        imports = with config.flake.modules.homeManager; [
            server
        ];
    };
}
