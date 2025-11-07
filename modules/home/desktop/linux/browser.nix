{
    flake.modules.homeManager.desktop-linux = {
        config,
        pkgs,
        ...
    }: {
        home.packages = with pkgs; [firefoxpwa];
        programs.firefox = {
            enable = true;
            nativeMessagingHosts = with pkgs; [firefoxpwa];
            policies = {
                Preferences = {
                    "media.gmp-widevinecdm.version" = "system-installed";
                    "media.gmp-widevinecdm.visible" = true;
                    "media.gmp-widevinecdm.enabled" = true;
                    "media.gmp-widevinecdm.autoupdate" = false;
                    "media.eme.enabled" = true;
                    "media.eme.encrypted-media-encryption-scheme.enabled" = true;
                };
            };
        };
        xdg.systemDirs.data = ["${config.xdg.dataHome}"];
        xdg.desktopEntries = {
            glide = {
                name = "Glide";
                genericName = "Web Browser";
                exec = "glide %u";
                terminal = false;
                categories = ["Network" "WebBrowser"];
                mimeType = ["text/html" "text/xml"];
                type = "Application";
            };
        };
    };
}
