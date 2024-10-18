{ pkgs, config, ... }:

let
  user = "caligula";
in

{

  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    ../../modules/shared/cachix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nixVersions.git;
    settings.trusted-users = [
      "@admin"
      "${user}"
    ];

    gc = {
      user = "root";
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = (import ../../modules/shared/packages.nix { inherit pkgs; });

  security = {
    pam.enableSudoTouchIdAuth = true;
    sudo.extraConfig = ''
      Defaults    timestamp_timeout=30
    '';
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      hyper - a : open -a ${config.environment.variables.SKHD_1_1}
      hyper - s : open -a ${config.environment.variables.SKHD_1_2}
      hyper - d : open -a ${config.environment.variables.SKHD_1_3}
      hyper - f : open -a ${config.environment.variables.SKHD_1_4}
      hyper - q : open -a ${config.environment.variables.SKHD_2_1}
      hyper - w : open -a ${config.environment.variables.SKHD_2_2}
      hyper - e : open -a ${config.environment.variables.SKHD_2_3}
      hyper - r : open -a ${config.environment.variables.SKHD_2_4}
    '';
  };

  environment.systemPath = [ "${pkgs.skhd}/bin" ];
  environment.variables = {
    EDITOR = "nvim";
    SKHD_1_1 = "Wezterm";
    SKHD_1_2 = "Safari";
    SKHD_1_3 = "Slack";
    SKHD_1_4 = "Github";
    SKHD_2_1 = "Calendar";
    SKHD_2_2 = "Mail";
    SKHD_2_3 = "Spotify";
    SKHD_2_4 = "Jira";
  };

  system = {
    stateVersion = 4;

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
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };

      screencapture.location = "/Users/caligula/Pictures/screenshots/";
      screensaver.askForPassword = true;
      loginwindow.SHOWFULLNAME = true;

      trackpad = {
        Clicking = false;
        TrackpadThreeFingerDrag = false;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
