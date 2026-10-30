{
    flake.modules.nixos.gui = { lib, pkgs, ... }: {
        environment.systemPackages = with pkgs; [ keyd ];
        # The external keyboards (Lily58, Idobao80) are US. Hosts with a non-US
        # built-in keyboard set its layout per device on keyd's virtual keyboard.
        services.xserver.xkb.layout = lib.mkDefault "us";
        # Console follows the same layout.
        console.useXkbConfig = true;
        services.logind.settings.Login = {
            HandlePowerKey = "ignore";
            HandlePowerKeyLongPress = "poweroff";
        };
        # keyd only grabs built-in keyboards, so keyd_virtual_keyboard is always
        # the built-in one and external keyboards keep their own sway identity.
        services.keyd = {
            enable = true;
            keyboards.framework = {
                ids = [ "32ac:0018:8a529b7" ];
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
