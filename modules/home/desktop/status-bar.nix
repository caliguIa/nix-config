{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        stylix.targets.waybar.enable = false;
        programs.waybar = {
            enable = true;
            systemd.enable = true;
            settings = {
                mainBar = let
                    key = label: {colour ? "#666662"}: ''<span size="small" weight="bold" color="${colour}" rise="2pt">${label}</span>'';
                in {
                    layer = "top";
                    position = "top";
                    height = 32;
                    reload_style_on_change = true;
                    modules-left = ["clock#time" "clock#date" "custom/meeting"];
                    modules-center = [];
                    modules-right = ["power-profiles-daemon" "cpu" "memory" "bluetooth" "network" "pulseaudio" "battery"];
                    power-profiles-daemon = {
                        format = "${key "PWR" {}} {profile}";
                        tooltip = false;
                    };
                    cpu = {
                        format = "${key "CPU" {}} {usage} ${key "%" {}}";
                        interval = 2;
                        tooltip = false;
                    };
                    memory = {
                        format = "${key "MEM" {}} {used:0.1f} ${key "GB" {}}";
                        tooltip = false;
                    };
                    bluetooth = {
                        format-on = "${key "BT" {}} DISC.";
                        format-off = "${key "BT" {}} OFF";
                        format-disabled = "${key "BT" {}} OFF";
                        format-connected = "${key "BT" {}} {device_alias}";
                        tooltip = false;
                        on-click = "${pkgs.overskride}/bin/overskride";
                    };
                    battery = {
                        format = "${key "BAT" {}} {capacity} ${key "%" {}}${key " CHG" {colour = "#c8c7c5";}}";
                        format-charging = "${key "BAT" {}} {capacity} ${key "% CHG" {}}";
                        format-plugged = "${key "BAT" {}} {capacity} ${key "% CHG" {}}";
                        tooltip = false;
                    };
                    "clock#date" = {
                        format = "${key "DATE" {}} {:%a %d %b}";
                        interval = 60;
                        tooltip = false;
                    };
                    "clock#time" = {
                        format = "${key "TIME" {}} {0:%H}:{0:%M}:{0:%S}";
                        interval = 1;
                        tooltip = false;
                    };
                    network = {
                        format-wifi = "${key "WIFI" {}} {essid} ${key "{frequency}GHz" {}}";
                        format-disconnected = "${key "WIFI" {}} DISC.";
                        format-ethernet = "${key "ETH" {}} {ifname}";
                        tooltip = false;
                        on-click = "${pkgs.iwmenu}/bin/iwmenu -l fuzzel";
                        on-click-right = "${pkgs.iwgtk}/bin/iwgtk";
                    };
                    pulseaudio = {
                        on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
                        tooltip = false;
                        scroll-step = 5;
                        format = "${key "VOL" {}} {volume} ${key "%" {}}";
                        format-muted = "${key "VOL" {}} MUT";
                    };
                    "custom/meeting" = {
                        format = "{}";
                        return-type = "json";
                        interval = 30;
                        tooltip = true;
                        exec = pkgs.writeShellScriptBin "khal-waybar" ''
                            set -euo pipefail

                            DIM='#666662'

                            key() {
                              echo -n "<span size=\"small\" weight=\"bold\" color=\"''${DIM}\">''${1}</span>"
                            }

                            sep() {
                              key " · "
                            }

                            fmt_mins() {
                              local mins=''${1}
                              if (( mins >= 60 )); then
                                local h=$(( mins / 60 ))
                                local m=$(( mins % 60 ))
                                if (( m == 0 )); then
                                  echo -n "''${h}h"
                                else
                                  echo -n "''${h}h''${m}m"
                                fi
                              else
                                echo -n "''${mins}m"
                              fi
                            }

                            now_epoch=$(date +%s)

                            in_meeting_json=$(
                              ${pkgs.khal}/bin/khal at now \
                                --json title \
                                --json start-full \
                                --json end-full \
                                --json all-day \
                                --no-color \
                                2>/dev/null || echo '[]'
                            )

                            current_event=$(
                              echo "''${in_meeting_json}" \
                              | ${pkgs.jq}/bin/jq -c 'map(select(.["all-day"] == false)) | first // empty' \
                              2>/dev/null || true
                            )

                            if [[ -n "''${current_event}" ]]; then
                              title=$(echo "''${current_event}" | ${pkgs.jq}/bin/jq -r '.title')
                              end_str=$(echo "''${current_event}" | ${pkgs.jq}/bin/jq -r '."end-full"')

                              end_epoch=$(date -d "''${end_str}" +%s)
                              mins_left=$(( (end_epoch - now_epoch + 59) / 60 ))
                              (( mins_left < 1 )) && mins_left=1

                              time_str=$(fmt_mins "''${mins_left}")
                              text="$(key LEFT)$(sep)''${time_str}$(sep)''${title}"
                              tooltip="''${title} — ends ''${end_str}"

                              printf '{"text":"%s","tooltip":"%s","class":"active"}\n' \
                                "''${text}" "''${tooltip}"
                              exit 0
                            fi

                            upcoming_json=$(
                              ${pkgs.khal}/bin/khal list now 24h \
                                --json title \
                                --json start-full \
                                --json all-day \
                                --notstarted \
                                --no-color \
                                2>/dev/null || echo '[]'
                            )

                            next_event=$(
                              echo "''${upcoming_json}" \
                              | ${pkgs.jq}/bin/jq -c 'map(select(.["all-day"] == false)) | first // empty' \
                              2>/dev/null || true
                            )

                            if [[ -n "''${next_event}" ]]; then
                              title=$(echo "''${next_event}" | ${pkgs.jq}/bin/jq -r '.title')
                              start_str=$(echo "''${next_event}" | ${pkgs.jq}/bin/jq -r '."start-full"')

                              start_epoch=$(date -d "''${start_str}" +%s)
                              mins_until=$(( (start_epoch - now_epoch) / 60 ))
                              (( mins_until < 1 )) && mins_until=1

                              time_str=$(fmt_mins "''${mins_until}")
                              text="$(key IN)$(sep)''${time_str}$(sep)''${title}"
                              tooltip="''${title} — starts ''${start_str}"

                              printf '{"text":"%s","tooltip":"%s","class":"soon"}\n' \
                                "''${text}" "''${tooltip}"
                              exit 0
                            fi

                            text="$(key MTG)$(sep)NONE"
                            printf '{"text":"%s","tooltip":"No upcoming meetings","class":"none"}\n' "''${text}"
                        '';
                    };
                };
            };
            style = pkgs.writeText "waybar.css" ''
                @define-color bg     #f2f1ef;
                @define-color fg     #1a1a18;
                * {
                  font-family: "Berkeley Mono", monospace;
                  font-size: 18px;
                  border: none;
                  border-radius: 0;
                  padding: 0;
                  margin: 0;
                }
                window#waybar {
                    border-bottom: 1px solid @fg;
                }
                .module {
                  padding: 0 10px;
                  color: @fg;
                  font-weight: 700;
                  background: transparent;
                }
                .modules-left .module {
                  border-right: 1px solid @fg;
                }
                .modules-right .module {
                  border-left: 1px solid @fg;
                }
            '';
        };
    };
}
