{user, ...}: {
    flake.modules.nixos.host_smiley._module.args = {
        mediaService = overrides:
            {
                enable = true;
                openFirewall = false;
                user = user.media;
                group = user.media;
            }
            // overrides;

        mediaDir = path: "d ${path} 2775 ${user.media} ${user.media} -";
    };
}
