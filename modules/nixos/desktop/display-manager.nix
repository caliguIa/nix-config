{
    flake.modules.nixos.desktop = {
        services.greetd = {
            enable = true;
        };
        programs.regreet = {
            enable = true;
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
