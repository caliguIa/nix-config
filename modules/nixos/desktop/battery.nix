{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.power-profiles-daemon.enable = true;
        systemd.user.services.battery-monitor = {
            description = "Battery level monitor";
            after = ["graphical-session.target"];
            wantedBy = ["graphical-session.target"];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.writeShellScript "battery-monitor" ''
                    STATE_FILE="/tmp/battery-notif-state"
                    BATTERY_PATH="/sys/class/power_supply/BAT1"

                    check_battery() {
                        CAPACITY=$(cat "$BATTERY_PATH/capacity")
                        STATUS=$(cat "$BATTERY_PATH/status")

                        if [ "$STATUS" != "Discharging" ]; then
                            rm -f "$STATE_FILE"
                            return
                        fi

                        PREV_STATE=""
                        [ -f "$STATE_FILE" ] && PREV_STATE=$(cat "$STATE_FILE")

                        if [ "$CAPACITY" -le 5 ] && [ "$PREV_STATE" != "5" ]; then
                            ${pkgs.libnotify}/bin/notify-send -t 0 -u critical "Battery Critical" "Battery at ''${CAPACITY}%. Please plug in charger!"
                            echo "5" > "$STATE_FILE"
                        elif [ "$CAPACITY" -le 15 ] && [ "$PREV_STATE" != "15" ] && [ "$PREV_STATE" != "5" ]; then
                            ${pkgs.libnotify}/bin/notify-send -t 0 -u normal "Battery Low" "Battery at ''${CAPACITY}%"
                            echo "15" > "$STATE_FILE"
                        fi
                    }

                    check_battery

                    ${pkgs.inotify-tools}/bin/inotifywait -m -e modify "$BATTERY_PATH/capacity" | while read -r; do
                        check_battery
                    done
                ''}";
                Restart = "on-failure";
                RestartSec = "5s";
            };
        };
    };
}
