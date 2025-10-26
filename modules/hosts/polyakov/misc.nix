topLevel @ {...}: {
    flake.modules.darwin.host_polyakov = {config, ...}: {
        system.defaults.screencapture.location = "${config.users.users.${topLevel.config.flake.meta.users.primary}.home}/Pictures/screenshots/";
    };
}
