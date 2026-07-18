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

        # systemd-tmpfiles rule for a group-writable, setgid directory owned by
        # the media user/group. Mode 2775: owner+group rwx, setgid so new files
        # and subdirs inherit the media group, letting group members (caligula)
        # create content. Uses "d" so existing content modes aren't recursed.
        mediaDir = path: "d ${path} 2775 ${user.media} ${user.media} -";
    };
}
