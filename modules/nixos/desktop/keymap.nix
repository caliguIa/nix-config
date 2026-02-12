{
    flake.modules.nixos.system-desktop-keymap = {
        services.logind = {
            powerKey = "ignore";
            powerKeyLongPress = "poweroff";
        };
        services.keyd = {
            enable = true;
            keyboards.default = {
                ids = ["*"];
                settings = {
                    main = {
                        esc = "capslock";
                        capslock = "esc";
                        leftcontrol = "layer(alt)";
                        leftalt = "layer(control)";
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
