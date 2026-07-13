{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [keyd];
        services.xserver.xkb.layout = "gb";
        services.logind.settings.Login = {
            HandlePowerKey = "ignore";
            HandlePowerKeyLongPress = "poweroff";
        };
        services.keyd = {
            enable = true;
            keyboards.default = {
                settings = {
                    "meta:C" = {
                        h = "left";
                        j = "down";
                        k = "up";
                        l = "right";
                    };
                };
            };
            keyboards.framework = {
                ids = ["32ac:0018:8a529b7"];
                settings = {
                    main = {
                        esc = "capslock";
                        capslock = "esc";
                        leftalt = "layer(control)";
                        leftmeta = "layer(alt)";
                        rightalt = "layer(control)";
                        rightcontrol = "layer(meta)";
                    };
                };
            };
        };
    };
}
