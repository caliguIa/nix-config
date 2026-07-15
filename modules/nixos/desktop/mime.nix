{
    flake.modules.nixos.desktop = {
        xdg.mime = {
            enable = true;
            defaultApplications = {
                "application/pdf" = "zathura.desktop";
                "application/json" = "nvim.desktop";
                "application/mp4" = "mpv.desktop";
                "application/yaml" = "nvim.desktop";
                "application/zip" = "unzip.desktop";
                "application/zip-compressed" = "unzip.desktop";
                "audio/*" = "mpv.desktop";
                "image/*" = "imv.desktop";
                "text/*" = "nvim.desktop";
                "text/html" = ["zen-twilight.desktop" "nvim.desktop"];
                "text/markdown" = ["zen-twilight.desktop" "nvim.desktop"];
                "video/*" = "mpv.desktop";
            };
        };
    };
}
