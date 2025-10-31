{
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

    flake.modules.nixos.system-desktop-keymap = {
        services.kanata = {
            enable = true;
            keyboards.internalKeyboard.config = ''
                (defsrc
                  caps
                  rmet
                  h    j    k    l
                  KEY_FN
                )

                (defalias
                  h (fork h left (rctl))
                  j (fork j down (rctl))
                  k (fork k up (rctl))
                  l (fork l rght (rctl))
                )

                (deflayer base
                  esc
                  rctl
                  @h   @j   @k   @l
                  KEY_FN
                )
            '';
        };
    };
}
