{user, ...}: {
    # Helpers shared by smiley's media services, exposed as module arguments
    # scoped to this host only (not the whole flake).
    flake.modules.nixos.host_smiley._module.args = {
        # Shared media-service defaults merged with per-service overrides.
        mediaService = overrides:
            {
                enable = true;
                openFirewall = false;
                user = user.media;
                group = user.media;
            }
            // overrides;

        # systemd-tmpfiles rule for a 0755 directory owned by the media user.
        mediaDir = path: "d ${path} 0755 ${user.media} ${user.media} -";
    };
}
