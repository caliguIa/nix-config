{
    flake.modules.nixos.desktop = {
        services.displayManager = {
            plasma-login-manager.enable = true;
        };
        services.greetd = {
            enable = false;
        };
        programs.regreet = {
            enable = false;
            settings = {
                widget.clock = {
                    format = "%T\n%A %B %e, %Y\nTime zone: %:V";
                    resolution = "1000ms";
                    timezone = "Europe/London";
                };
            };
        };
        stylix.targets.regreet.enable = true;
    };
}
