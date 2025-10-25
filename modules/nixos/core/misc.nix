{self, ...}: {
    flake.modules.darwin.core = {
        imports = [self.modules.generic.system-core-misc];
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
        imports = [self.modules.generic.system-core-misc];
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
    };

    flake.modules.generic.system-core-misc = {
        time.timeZone = "Europe/London";
    };
}
