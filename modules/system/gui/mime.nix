{
    flake.modules.nixos.gui = {
        xdg.mime = {
            enable = true;
            defaultApplications = {
                "application/pdf" = "org.pwmt.zathura.desktop";
                "application/json" = "nvim.desktop";
                "application/mp4" = "mpv.desktop";
                "application/yaml" = "nvim.desktop";
                "audio/*" = "mpv.desktop";
                "image/*" = "imv.desktop";
                "inode/directory" = "org.gnome.Nautilus.desktop";
                "text/*" = "nvim.desktop";
                "text/html" = [
                    "zen-twilight.desktop"
                    "nvim.desktop"
                ];
                "application/xhtml+xml" = "zen-twilight.desktop";
                "x-scheme-handler/http" = "zen-twilight.desktop";
                "x-scheme-handler/https" = "zen-twilight.desktop";
                "text/markdown" = [
                    "zen-twilight.desktop"
                    "nvim.desktop"
                ];
                "video/*" = "mpv.desktop";
            };
        };
        # Terminal=true launchers (nvim.desktop) need to know the terminal.
        xdg.terminal-exec = {
            enable = true;
            settings.default = [ "com.mitchellh.ghostty.desktop" ];
        };
    };
}
