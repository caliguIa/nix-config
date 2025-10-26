{lib, ...}: {
    options.flake.meta.users = {
        primary = lib.mkOption {
            default = "caligula";
        };
        media = lib.mkOption {
            default = "media";
        };
    };
}
