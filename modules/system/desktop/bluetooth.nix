{
    flake.modules.nixos.desktop = {
        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
            settings = {
                General = {
                    Experimental = true;
                    FastConnectable = false;
                    JustWorksRepairing = "always";
                    Privacy = "device";
                };
                Policy = {
                    AutoEnable = true;
                };
            };
        };
    };
}
