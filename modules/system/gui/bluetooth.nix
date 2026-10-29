{
    flake.modules.nixos.gui = {
        # Realtek adapters (e.g. tarr's RTL8852BU) miss LE reconnects after
        # USB autosuspend.
        boot.extraModprobeConfig = "options btusb enable_autosuspend=0";

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
