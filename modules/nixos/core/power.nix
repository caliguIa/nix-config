{
    flake.modules.darwin.core = {
        power = {
            sleep = {
                allowSleepByPowerButton = true;
                computer = 10;
                harddisk = 10;
                display = 5;
            };
        };
        system = {
            startup.chime = false;
            defaults = {
                controlcenter.BatteryShowPercentage = true;
            };
        };
    };

    flake.modules.nixos.core = {
    };
}
