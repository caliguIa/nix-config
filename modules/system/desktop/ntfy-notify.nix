{
    flake.modules.hjem.desktop = {pkgs, ...}: let
        server = "https://ntfy.smiley.calrichards.io";
        topics = ["smiley-music"];
        notify = pkgs.writeShellApplication {
            name = "ntfy-notify-exec";
            runtimeInputs = [pkgs.libnotify];
            text = ''
                # shellcheck disable=SC2154
                notify-send --app-name=ntfy "''${title:-$topic}" "$message"
            '';
        };
    in {
        packages = [pkgs.ntfy-sh pkgs.libnotify];

        systemd.services.ntfy-notify = {
            description = "Desktop notifications from ntfy (${builtins.concatStringsSep ", " topics})";
            after = ["graphical-session.target"];
            partOf = ["graphical-session.target"];
            wantedBy = ["graphical-session.target"];
            serviceConfig = {
                ExecStart = "${pkgs.ntfy-sh}/bin/ntfy subscribe ${server}/${builtins.concatStringsSep "," topics} ${notify}/bin/ntfy-notify-exec";
                Restart = "always";
                RestartSec = 10;
            };
        };
    };
}
