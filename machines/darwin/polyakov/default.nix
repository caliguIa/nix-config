{
    pkgs,
    config,
    username,
    hostname,
    inputs,
    ...
}: {
    nixpkgs.config.allowUnfree = true;

    nix = {
        enable = true;
        package = pkgs.nix;
        optimise.automatic = true;
        nixPath = ["nixpkgs=${inputs.nixpkgs}"];
        settings = {
            trusted-users = [
                "@admin"
                "${username}"
            ];
            substituters = [
                "https://nix-community.cachix.org"
                "https://cache.nixos.org"
            ];
            trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];
        };

        gc = {
            automatic = true;
            interval = {
                Weekday = 0;
                Hour = 2;
                Minute = 0;
            };
            options = "--delete-older-than 30d";
        };

        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    power = {
        sleep = {
            allowSleepByPowerButton = true;
            computer = 10;
            harddisk = 10;
            display = 5;
        };
    };

    homebrew = {
        enable = true;
        casks = import ./casks.nix {inherit pkgs;};
        taps = builtins.attrNames config.nix-homebrew.taps;
        onActivation = {
            autoUpdate = true;
            cleanup = "zap";
            upgrade = true;
        };
    };

    imports = [
        ./packages.nix
        ./services/aerospace.nix
        ./services/karabiner.nix
    ];

    environment = {
        systemPackages = import ../../../modules/common/packages.nix {inherit pkgs;};
        systemPath = [
            "/Users/${username}/.cargo/bin"
            "/Users/${username}/.local/bin"
            "/Users/${username}/go/bin"
            "/Applications/Docker.app/Contents/Resources/bin"
        ];
        variables = {
            EDITOR = "nvim";
        };
    };

    networking = {
        computerName = hostname;
        hostName = hostname;
        dns = ["8.8.8.8"];
        knownNetworkServices = [
            "USB 10/100/1000 LAN"
            "Thunderbolt Bridge"
            "Wi-Fi"
            "iPhone USB"
        ];
    };

    security = {
        pam.services.sudo_local = {
            enable = true;
            touchIdAuth = true;
            reattach = true;
        };
        sudo.extraConfig = ''
            Defaults    timestamp_timeout=15
        '';
    };
    time.timeZone = "Europe/London";

    system = {
        stateVersion = 4;
        primaryUser = username;
        checks.verifyNixPath = false;
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

            alf = {
                globalstate = 1;
                stealthenabled = 1;
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

            trackpad = {
                Clicking = false;
                TrackpadThreeFingerDrag = false;
            };
            menuExtraClock = {
                FlashDateSeparators = false;
                Show24Hour = true;
                ShowDate = 1;
                ShowDayOfMonth = true;
                ShowDayOfWeek = true;
                ShowSeconds = true;
            };
        };

        keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
        };
    };

    home-manager.sharedModules = [
        {
            imports = [
                ../../../modules/common/ghostty
                ../../../modules/common/kanata
            ];
            programs.direnv = {
                enable = true;
                enableZshIntegration = true;
                silent = true;
            };
        }
    ];
}
