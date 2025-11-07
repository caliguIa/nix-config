{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        home.packages =
            if pkgs.stdenvNoCC.isDarwin
            then [pkgs.kanata]
            else [];
        xdg.configFile =
            if pkgs.stdenvNoCC.isDarwin
            then {
                "kanata/kanata.kbd".text = ''
                    (defsrc
                      caps
                      rmet
                      fn
                      h    j    k    l
                      f1   f2   f3   f4   f5   f6
                      f7   f8   f9   f10  f11  f12
                    )

                    (defalias
                      ;; Vim arrow keys with right ctrl
                      h (fork h left (rctl))
                      j (fork j down (rctl))
                      k (fork k up (rctl))
                      l (fork l rght (rctl))

                      ;; Function keys with fn modifier
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

                    (deflayer base
                      esc
                      rctl
                      fn
                      @h   @j   @k   @l
                      @f1  @f2  @f3  @f4  @f5  @f6
                      @f7  @f8  @f9  @f10 @f11 @f12
                    )
                '';
            }
            else {};
    };
}
