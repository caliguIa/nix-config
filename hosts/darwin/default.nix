{ pkgs, config, ... }:

let
  user = "caligula";
in

{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
  ];

  nix = {
    enable = true;
    package = pkgs.nix;
    settings = {
      trusted-users = [
        "@admin"
        "${user}"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
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

  system.checks.verifyNixPath = false;

  environment.systemPackages = (import ../../modules/shared/packages.nix { inherit pkgs; });

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

  environment.systemPath = [
    "${config.users.users.${user}.home}/.cargo/bin"
    "${config.users.users.${user}.home}/.local/bin"
    "${config.users.users.${user}.home}/go/bin"
  ];

  environment.variables = {
    EDITOR = "nvim";
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
