{
  pkgs,
  username,
  ...
}:

{
  # launchd.daemons.kanata = {
  #   script = "${pkgs.kanata}/bin/kanata -c /Users/${username}/.config/kanata/kanata.kbd";
  #   serviceConfig = {
  #     Label = "org.nixos.kanata";
  #     RunAtLoad = true;
  #     KeepAlive = true;
  #     StandardOutPath = "/Library/Logs/Kanata/kanata.out.log";
  #     StandardErrorPath = "/Library/Logs/Kanata/kanata.err.log";
  #   };
  # };
  # launchd.daemons.karabiner-vhiddaemon = {
  #   script = "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
  #   serviceConfig = {
  #     Label = "org.nixos.karabiner-vhiddaemon";
  #     RunAtLoad = true;
  #     KeepAlive = true;
  #   };
  # };
  # launchd.daemons.karabiner-vhidmanager = {
  #   script = "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager";
  #   serviceConfig = {
  #     Label = "org.nixos.karabiner-vhidmanager";
  #     RunAtLoad = true;
  #     KeepAlive = true;
  #   };
  # };

  environment.etc."sudoers.d/kanata".source = pkgs.runCommand "sudoers-kanata" { } ''
    KANATA_BIN="${pkgs.kanata}/bin/kanata"
    SHASUM=$(sha256sum "$KANATA_BIN" | cut -d' ' -f1)
    # RES="NOPASSWD:SETENV: sha256:$SHASUM $KANATA_BIN"
    RES="NOPASSWD:SETENV: $KANATA_BIN"
    cat <<EOF >"$out"
    %admin ALL=(root) $RES
    caligula ALL=(ALL) $RES
    root ALL=(ALL) $RES
    EOF
  '';
  environment.launchDaemons."org.nixos.kanata.plist" = {
    enable = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <\!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>org.nixos.kanata</string>

          <key>ProgramArguments</key>
          <array>
              <string>${pkgs.kanata}/bin/kanata</string>
              <string>-c</string>
              <string>/Users/${username}/.config/kanata/kanata.kbd</string>
          </array>

          <key>RunAtLoad</key>
          <true/>

          <key>KeepAlive</key>
          <true/>

          <key>StandardOutPath</key>
          <string>/var/log/kanata.out.log</string>

          <key>StandardErrorPath</key>
          <string>/var/log/kanata.err.log</string>

          <key>ProcessType</key>
          <string>Interactive</string>
          
          <key>OtherJobEnabled</key>
          <dict>
            <key>org.nixos.karabiner-vhidmanager</key>
            <true />
          </dict>
      </dict>
      </plist>
    '';
  };
}
