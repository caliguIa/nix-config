let
    username = "caligula";
in {
    flake.modules.darwin.system = {
        power = {
            sleep = {
                allowSleepByPowerButton = true;
                computer = 10;
                harddisk = 10;
                display = 5;
            };
        };
        time.timeZone = "Europe/London";
        system = {
            startup.chime = false;
            defaults = {
                NSGlobalDomain = {
                    "com.apple.mouse.tapBehavior" = 1;
                    "com.apple.sound.beep.volume" = 0.5;
                    "com.apple.sound.beep.feedback" = 0;
                    AppleShowAllExtensions = true;
                    ApplePressAndHoldEnabled = false;
                    AppleEnableMouseSwipeNavigateWithScrolls = false;
                    AppleEnableSwipeNavigateWithScrolls = false;
                    AppleICUForce24HourTime = true;
                    AppleInterfaceStyle = "Dark";
                    AppleShowAllFiles = true;
                    AppleShowScrollBars = "WhenScrolling";
                    AppleWindowTabbingMode = "always";
                    InitialKeyRepeat = 12;
                    KeyRepeat = 2;
                    NSAutomaticCapitalizationEnabled = false;
                    NSAutomaticDashSubstitutionEnabled = false;
                    NSAutomaticPeriodSubstitutionEnabled = false;
                    NSAutomaticQuoteSubstitutionEnabled = false;
                    NSAutomaticSpellingCorrectionEnabled = false;
                    NSAutomaticWindowAnimationsEnabled = false;
                    NSNavPanelExpandedStateForSaveMode = true;
                    NSTableViewDefaultSizeMode = 1;
                };
                controlcenter.BatteryShowPercentage = true;
                dock = {
                    orientation = "bottom";
                    autohide-delay = 5.0;
                    autohide = true;
                    launchanim = false;
                    mru-spaces = false;
                    show-recents = false;
                    static-only = true;
                    tilesize = 1;
                    wvous-bl-corner = 1;
                    wvous-br-corner = 1;
                    wvous-tl-corner = 1;
                    wvous-tr-corner = 1;
                };
                finder = {
                    AppleShowAllExtensions = true;
                    AppleShowAllFiles = true;
                    CreateDesktop = false;
                    FXDefaultSearchScope = "SCcf";
                    FXPreferredViewStyle = "clmv";
                    FXRemoveOldTrashItems = true;
                    NewWindowTarget = "Home";
                    ShowPathbar = true;
                    ShowStatusBar = true;
                    _FXSortFoldersFirst = true;
                    _FXShowPosixPathInTitle = true;
                };
                screencapture.location = "/Users/${username}/Pictures/screenshots/";
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

    flake.modules.nixos.system = {
        imports = [./_hardware-configuration.nix];
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        systemd.tmpfiles.rules = ["d /data 0755 root root -"];
        time.timeZone = "Europe/London";
    };
}
