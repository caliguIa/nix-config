{
    flake.modules.darwin.core = {
        time.timeZone = "Europe/London";
        system = {
            defaults = {
                NSGlobalDomain = {
                    "com.apple.sound.beep.volume" = 0.5;
                    "com.apple.sound.beep.feedback" = 0;
                    AppleICUForce24HourTime = true;
                };
                screensaver.askForPassword = true;
                loginwindow = {
                    SHOWFULLNAME = true;
                    LoginwindowText = "hello my absolute mate";
                };
                SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
                menuExtraClock = {
                    FlashDateSeparators = false;
                    Show24Hour = true;
                    ShowDate = 1;
                    ShowDayOfMonth = true;
                    ShowDayOfWeek = true;
                    ShowSeconds = true;
                };
            };
        };
    };

    flake.modules.nixos.core = {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        time.timeZone = "Europe/London";
    };
}
