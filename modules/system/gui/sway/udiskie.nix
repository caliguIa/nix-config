{
    flake.modules.nixos.gui =
        { lib, pkgs, ... }:
        {
            systemd.user.services.udiskie = {
                # Inherit the session PATH so it can find the user's file manager.
                enableDefaultPath = false;
                description = "udiskie removable media automounter";
                partOf = [ "sway-session.target" ];
                after = [ "sway-session.target" ];
                wantedBy = [ "sway-session.target" ];
                serviceConfig = {
                    ExecStart = "${lib.getExe pkgs.udiskie} --automount --notify --smart-tray --appindicator";
                    Restart = "on-failure";
                };
            };
        };
}
