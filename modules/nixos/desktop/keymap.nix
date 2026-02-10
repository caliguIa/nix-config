let
    kanataConfig = ''
        (defcfg danger-enable-cmd yes)
        (deflocalkeys-linux fn 464)
        (defsrc
          caps
          lmet
          rmet
          ralt
          fn
          h    j    k    l
          f1   f2   f3   f4   f5   f6
          f7   f8   f9   f10  f11  f12
        )
        (defalias
          rct (multi rctl (layer-while-held arrows))
          h (multi (release-key rctl) left)
          j (multi (release-key rctl) down)
          k (multi (release-key rctl) up)
          l (multi (release-key rctl) rght)
        )
        (platform (linux)
            (deflayer base
              esc
              lctl
              @rct
              rmet
              _
              h    j    k    l
              _  _  _  _  _  _
              _  _  _  _  _  _
            )
        )
        (platform (macos)
          (defalias
            f1 (fork brdn f1 (fn))
            f2 (fork brup f2 (fn))
            f3 (fork f3 f3 (fn))
            f4 (fork f4 f4 (fn))
            f5 (fork f5 f5 (fn))
            f6 (fork f6 f6 (fn))
            f7 (fork prev f7 (fn))
            f8 (fork pp f8 (fn))
            f9 (fork next f9 (fn))
            f10 (fork mute f10 (fn))
            f11 (fork vold f11 (fn))
            f12 (fork volu f12 (fn))
          )
        )
        (platform (macos)
          (deflayer base
            esc
            _
            @rct
            _
            fn
            h    j    k    l
            @f1  @f2  @f3  @f4  @f5  @f6
            @f7  @f8  @f9  @f10 @f11 @f12
          )
        )
        (deflayer arrows
          _
          _
          _
          _
          _
          @h   @j   @k   @l
          _  _  _  _  _  _
          _  _  _  _  _  _
        )
    '';
in {
    flake.modules.darwin.system-desktop-keymap = {
        system = {
            keyboard = {
                enableKeyMapping = true;
                remapCapsLockToEscape = true;
            };
            defaults.NSGlobalDomain = {
                InitialKeyRepeat = 12;
                KeyRepeat = 2;
                ApplePressAndHoldEnabled = false;
                NSAutomaticCapitalizationEnabled = false;
                NSAutomaticDashSubstitutionEnabled = false;
                NSAutomaticPeriodSubstitutionEnabled = false;
                NSAutomaticQuoteSubstitutionEnabled = false;
                NSAutomaticSpellingCorrectionEnabled = false;
            };
        };
    };

    flake.modules.nixos.system-desktop-keymap = {pkgs, ...}: {
        services.kanata = {
            enable = false;
            package = pkgs.kanata-with-cmd;
            keyboards.internalKeyboard.configFile = "${pkgs.writeText "kanata.kbd" "${kanataConfig}"}";
        };
    };
}
