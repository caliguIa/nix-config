{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [keyd];
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
                        leftalt = "layer(control)";
                        leftmeta = "layer(alt)";
                        rightalt = "layer(control)";
                        rightcontrol = "layer(meta)";
                    };
                    "meta:C" = {
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
