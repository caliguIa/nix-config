{
    flake.modules.nixos.system-desktop-keymap = {
        services.keyd = {
            enable = true;
            keyboards.default = {
                ids = ["*"];
                settings = {
                    main = {
                        esc = "capslock";
                        leftcontrol = "layer(alt)";
                        leftalt = "layer(meta)";
                        meta = "layer(control)";
                        rightalt = "layer(control)";
                        rightcontrol = "layer(altgr)";
                    };
                    "altgr:C" = {
                        h = "left";
                        j = "down";
                        k = "up";
                        l = "right";
                    };
                };
            };
        };
    };
}
