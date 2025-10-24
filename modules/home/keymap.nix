{
    flake.modules.homeManager.keymap = {pkgs, ...}: {
        home.packages = [pkgs.kanata];
        xdg.configFile."kanata/kanata.kbd".text = ''
            (defcfg
              concurrent-tap-hold yes
            )

            (defsrc
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
              Backquote    1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [    ]
              caps a    s    d    f    g    h    j    k    l    ;    '    \    ret
              lsft IntlBackslash    z    x    c    v    b    n    m    ,    .    /    rsft
              fn   lctl lalt lmet           spc            rmet ralt
            )

            (defvar
              tap-time 200
              hold-time 200
            )

            (defalias
              ;; Modifiers
              ;; hyp (multi lsft lctl lmet lalt)  ;; Hyper key

              ;; Function key
              fnk (tap-hold $tap-time $hold-time fn (layer-toggle function))

              ;; Navigation with ctrl preserved
              nav (layer-toggle navigation)
              ctl-nav (multi rctl @nav)  ;; Right Ctrl activates nav layer while preserving Ctrl

              ;; Arrow keys that release ctrl when needed
              arr-l (multi (release-key rctl) left)
              arr-d (multi (release-key rctl) down)
              arr-u (multi (release-key rctl) up)
              arr-r (multi (release-key rctl) right)

              ;; Media keys
              bdn brdn
              bup brup
              prv prev
              pla pp
              nxt next
              mut mute
              vdn vold
              vup volu
            )

            ;; Base layer
            (deflayer base
              caps @bdn @bup _    _    _    _    @prv @pla @nxt @mut @vdn @vup
              Backquote    1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [    ]
              esc  a    s    d    f    g    h    j    k    l    ;    '    \    ret
              lsft `    z    x    c    v    b    n    m    ,    .    /    rsft
              @fnk lctl lalt lmet spc    @ctl-nav ralt
            )

            ;; Navigation layer - activated by right Ctrl
            (deflayer navigation
              _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    @arr-l @arr-d @arr-u @arr-r _ _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _              _              _    _    _    _
            )

            ;; Function key layer
            (deflayer function
              _    f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _              _              _    _    _    _
            )
        '';
    };

    flake.modules.darwin.keymap = {
        system = {
            keyboard = {
                enableKeyMapping = true;
                remapCapsLockToEscape = true;
            };
            trackpad = {
                Clicking = false;
                TrackpadThreeFingerDrag = false;
            };
        };
        environment.launchDaemons."org.nixos.karabiner-vhiddaemon.plist" = {
            enable = true;
            text = ''
                <?xml version="1.0" encoding="UTF-8"?>
                <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                <plist version="1.0">
                <dict>
                    <key>Label</key>
                    <string>org.nixos.karabiner-vhiddaemon</string>

                    <key>ProgramArguments</key>
                    <array>
                        <string>/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon</string>
                    </array>

                    <key>RunAtLoad</key>
                    <true/>

                    <key>KeepAlive</key>
                    <true/>
                </dict>
                </plist>
            '';
        };
        environment.launchDaemons."org.nixos.karabiner-vhidmanager.plist" = {
            enable = true;
            text = ''
                <?xml version="1.0" encoding="UTF-8"?>
                <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                <plist version="1.0">
                <dict>
                    <key>Label</key>
                    <string>org.nixos.karabiner-vhidmanager</string>

                    <key>ProgramArguments</key>
                    <array>
                        <string>/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager</string>
                        <string>activate</string>
                    </array>

                    <key>RunAtLoad</key>
                    <true/>

                    <key>OtherJobEnabled</key>
                    <dict>
                      <key>org.nixos.karabiner-vhiddaemon</key>
                      <true />
                    </dict>
                </dict>
                </plist>
            '';
        };
    };

    flake.modules.nixos.keymap = {};
}
