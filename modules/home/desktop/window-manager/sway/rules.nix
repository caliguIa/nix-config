{
    flake.modules.homeManager.desktop = {
        wayland.windowManager.sway.config.window.commands = [
            # Floating - file dialogs
            { criteria = { title = "^Open File.*$"; }; command = "floating enable, move position center"; }
            { criteria = { title = "^Select a File.*$"; }; command = "floating enable, move position center"; }
            { criteria = { title = "^Choose wallpaper.*$"; }; command = "floating enable, move position center, resize set 60ppt 65ppt"; }
            { criteria = { title = "^Open Folder.*$"; }; command = "floating enable, move position center"; }
            { criteria = { title = "^Save As.*$"; }; command = "floating enable, move position center"; }
            { criteria = { title = "^Library.*$"; }; command = "floating enable, move position center"; }
            { criteria = { title = "^File Upload.*$"; }; command = "floating enable, move position center"; }
            { criteria = { title = ".*wants to save$"; }; command = "floating enable, move position center"; }
            { criteria = { title = ".*wants to open$"; }; command = "floating enable, move position center"; }
            # Floating - misc apps
            { criteria = { app_id = "blueberry.py"; }; command = "floating enable"; }
            { criteria = { app_id = "pavucontrol"; }; command = "floating enable, resize set 45ppt 45ppt, move position center"; }
            { criteria = { app_id = "org.pulseaudio.pavucontrol"; }; command = "floating enable, resize set 45ppt 45ppt, move position center"; }
            { criteria = { app_id = "nm-connection-editor"; }; command = "floating enable, resize set 45ppt 45ppt, move position center"; }
            { criteria = { app_id = "Zotero"; }; command = "floating enable, resize set 45ppt 45ppt, move position center"; }
            # Tiling
            { criteria = { app_id = "dev.warp.Warp"; }; command = "layout default"; }
            # Picture-in-Picture
            { criteria = { title = "^[Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture.*$"; }; command = "floating enable, sticky enable"; }
        ];
    };
}
