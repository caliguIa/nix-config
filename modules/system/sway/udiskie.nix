{
    flake.modules.nixos.sway =
        { lib, pkgs, ... }:
        {
            # Plasma's device notifier does this there; DMS has no removable-media support.
            systemd.user.services.udiskie = {
                description = "udiskie removable media automounter";
                partOf = [ "sway-session.target" ];
                after = [ "sway-session.target" ];
                wantedBy = [ "sway-session.target" ];
                serviceConfig = {
                    # Tray icon (via DMS's StatusNotifierItem host) only while a device is present.
                    ExecStart = "${lib.getExe pkgs.udiskie} --automount --notify --smart-tray --appindicator";
                    Restart = "on-failure";
                };
            };
        };
}
