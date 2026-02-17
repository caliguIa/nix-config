{
    flake.modules.nixos.desktop = {
        services.logind.settings.Login = {
            HandlePowerKey = "ignore";
            HandlePowerKeyLongPress = "poweroff";
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
                        rightcontrol = "layer(meta)";
                    };
                    "control:C" = {
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
