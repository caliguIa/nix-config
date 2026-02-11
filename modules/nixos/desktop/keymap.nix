{
    flake.modules.nixos.system-desktop-keymap = {pkgs, ...}: {
        services.kanata = {
            enable = false;
            package = pkgs.kanata-with-cmd;
            keyboards.internalKeyboard.configFile = pkgs.writeText "kanata.kbd" ''
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
        };
    };
}
