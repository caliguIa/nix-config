let
    username = "caligula";
in {
    flake.modules.darwin.wm = {
        services.aerospace = {
            enable = true;
            settings = {
                after-startup-command = [
                    "exec-and-forget sudo /etc/profiles/per-user/${username}/bin/kanata -c /Users/${username}/.config/kanata/kanata.kbd"
                ];
                enable-normalization-flatten-containers = true;
                enable-normalization-opposite-orientation-for-nested-containers = true;
                accordion-padding = 0;
                default-root-container-layout = "tiles";
                default-root-container-orientation = "auto";
                key-mapping.preset = "qwerty";
                gaps = {
                    inner.horizontal = 0;
                    inner.vertical = 0;
                    outer.left = 0;
                    outer.bottom = 0;
                    outer.top = 0;
                    outer.right = 0;
                };
                mode.main.binding = {
                    cmd-h = []; # Disable "hide application"
                    cmd-alt-h = []; # Disable "hide others"
                    alt-minus = "resize smart -50";
                    alt-equal = "resize smart +50";
                    alt-a = "workspace 1";
                    alt-s = "workspace 2";
                    alt-d = "workspace 3";
                    alt-f = "workspace 4";
                    alt-ctrl-a = "move-node-to-workspace 1";
                    alt-ctrl-s = "move-node-to-workspace 2";
                    alt-ctrl-d = "move-node-to-workspace 3";
                    alt-ctrl-f = "move-node-to-workspace 4";
                    alt-q = "exec-and-forget open -a /Applications/Ghostty.app";
                    alt-w = "exec-and-forget open -a '/Applications/Zen Browser.app'";
                    alt-e = "exec-and-forget open -a /Applications/Slack.app";
                    alt-r = "exec-and-forget open -a /Applications/Music.app";
                    alt-left = "focus left";
                    alt-down = "focus down";
                    alt-up = "focus up";
                    alt-right = "focus right";
                    alt-shift-h = "move left";
                    alt-shift-j = "move down";
                    alt-shift-k = "move up";
                    alt-shift-l = "move right";
                    alt-slash = "layout tiles horizontal vertical";
                    alt-comma = "layout accordion horizontal vertical";
                    alt-m = "fullscreen";
                    alt-semicolon = "mode service";
                };
                mode.service.binding = {
                    esc = [
                        "reload-config"
                        "mode main"
                    ];
                    r = [
                        "flatten-workspace-tree"
                        "mode main"
                    ]; # reset layout
                    f = [
                        "layout floating tiling"
                        "mode main"
                    ]; # Toggle between floating and tiling layout
                    backspace = [
                        "close-all-windows-but-current"
                        "mode main"
                    ];
                };
                on-window-detected = [
                    {
                        "if".app-name-regex-substring = "finder";
                        run = ["layout floating"];
                    }
                    {
                        "if".app-name-regex-substring = "mail";
                        run = ["layout floating"];
                    }
                    {
                        "if".app-name-regex-substring = "TablePlus";
                        run = ["layout floating"];
                    }
                ];
            };
        };
    };

    flake.modules.nixos.wm = {};
}
