{lib, config, ...}: let
    media = config.flake.meta.users.media;
in {
    options.flake.meta = {
        mediaService = lib.mkOption {
            type = lib.types.raw;
            description = ''
                Media-service constructor: returns the shared defaults (service
                enabled, firewall closed, runs as the media user/group) merged
                with the given per-service overrides. Overrides win on conflict.
            '';
        };
        mediaDir = lib.mkOption {
            type = lib.types.raw;
            description = "systemd-tmpfiles rule for a 0755 directory owned by the media user.";
        };
    };

    config.flake.meta = {
        mediaService = overrides:
            {
                enable = true;
                openFirewall = false;
                user = media;
                group = media;
            }
            // overrides;
        mediaDir = path: "d ${path} 0755 ${media} ${media} -";
    };
}
