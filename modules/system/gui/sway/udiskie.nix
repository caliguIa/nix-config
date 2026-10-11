{
    flake.modules.nixos.gui =
        { lib, pkgs, ... }:
        {
            systemd.user.services.udiskie = {
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
