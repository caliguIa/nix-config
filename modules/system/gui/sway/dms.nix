{ inputs, user, ... }:
{
    flake.modules.nixos.gui =
        { config, lib, pkgs, ... }:
        let
            # DMS's settings UI writes settings.json (only keys that differ from its
            # defaults) and session.json. These are merged over those files on every
            # start, so the keys below always win while anything else changed in the
            # UI is kept; to keep a UI change, copy it here. configVersion only seeds
            # a fresh file, so DMS's own migrations still run.
            # Timeouts are seconds; profile names are power-profiles-daemon indices
            # ("0" power-saver, "1" balanced).
            bar = {
                id = "default";
                name = "Main Bar";
                enabled = true;
                position = 0; # top
                screenPreferences = [ "all" ];
                showOnLastDisplay = true;
                leftWidgets = [ "launcherButton" "workspaceSwitcher" "focusedWindow" ];
                centerWidgets = [ "music" "clock" "weather" ];
                rightWidgets = [
                    "systemTray"
                    "clipboard"
                    "cpuUsage"
                    "memUsage"
                    "notificationButton"
                    "battery"
                    "controlCenterButton"
                ];
                spacing = 4;
                innerPadding = 4;
                barInsetPadding = -1;
                barLengthPadding = 0;
                barLengthMode = "full";
                barLengthPercent = 80;
                bottomGap = 0;
                attachToScreenEdge = true;
                followInterfaceStyle = false;
                transparency = 0.85;
                surfaceColor = "default";
                surfaceCustomColor = "#6750A4";
                widgetTransparency = 1;
                squareCorners = false;
                noBackground = false;
                widgetStyle = "pills";
                maximizeWidgetIcons = false;
                maximizeWidgetText = false;
                widgetPadding = 8;
                batteryColorMode = "theme";
                gothCornersEnabled = true;
                gothCornerRadiusOverride = false;
                gothCornerRadiusValue = 12;
                borderEnabled = false;
                borderColor = "surfaceText";
                borderOpacity = 1;
                borderThickness = 1;
                widgetOutlineEnabled = false;
                widgetOutlineColor = "primary";
                widgetOutlineOpacity = 1;
                widgetOutlineThickness = 1;
                fontScale = 1;
                iconScale = 1;
                autoHide = false;
                autoHideStrict = false;
                autoHideDelay = 250;
                showOnWindowsOpen = false;
                openOnOverview = false;
                visible = true;
                popupGapsAuto = true;
                popupGapsManual = 4;
                maximizeDetection = true;
                useOverlayLayer = false;
                scrollEnabled = true;
                scrollXBehavior = "column";
                scrollYBehavior = "workspace";
                shadowIntensity = 0;
                shadowOpacity = 60;
                shadowColorMode = "default";
                shadowCustomColor = "#000000";
                shadowDirectionMode = "inherit";
                shadowDirection = "top";
                clickThrough = false;
                hoverPopouts = false;
                hoverPopoutDelay = 150;
                island = false;
                dot = false;
                widgetFollowInterfaceStyle = true;
            };

            dmsSettings = {
                configVersion = 36;

                # Appearance
                currentThemeName = "dynamic";
                currentThemeCategory = "dynamic";
                customThemeFile = "${config.users.users.${user.primary}.home}/.config/DankMaterialShell/themes/darkmatter/theme.json";
                radiusStrength = 8;
                animationDuration = 200;
                blurBorderOpacity = 0.91;
                floatingWindowTransparency = 0.31;
                wallpaperFillMode = "Pad";
                fontFamily = "Noto Sans";
                monoFontFamily = "Berkeley Mono";
                useAutoLocation = true;

                # Power and idle
                acMonitorTimeout = 600; # 10 min
                acLockTimeout = 600; # 10 min
                acSuspendTimeout = 0; # never suspend on AC
                acProfileName = "1"; # balanced

                batteryMonitorTimeout = 300; # 5 min
                batteryLockTimeout = 300; # 5 min
                batterySuspendTimeout = 900; # 15 min
                batterySuspendBehavior = 0; # 0 = Suspend (not hibernate)
                batteryProfileName = "0"; # power-saver
                batteryNotifyLow = true;

                # Force power-saver below batteryLowThreshold (20%).
                batteryAutoPowerSaver = true;
                # Forces 60Hz on battery and re-applies on every output change,
                # fighting sway's own mode; adaptive sync saves the power instead.
                lowerDisplayRefreshRateOnBattery = false;

                # Lock screen
                lockBeforeSuspend = true;
                loginctlLockIntegration = true;
                lockScreenShowPowerActions = true;
                enableFprint = true;
                # Needed to wake the screen while locked. Without it, locking
                # re-arms the idle monitors, so when the monitor-off timeout
                # fires with (or before) the lock, input never registers as
                # "no longer idle" and the screen stays off until the 15-min
                # suspend. This enables DMS's input-driven lock wake monitor
                # (and blanks the screen as soon as it locks).
                lockScreenPowerOffMonitorsOnLock = true;

                barConfigs = [
                    bar
                    # Disabled floating "dot" bar, to toggle on from the UI.
                    (bar // {
                        id = "dot1790247829978";
                        name = "Dot";
                        enabled = false;
                        attachToScreenEdge = false;
                        gothCornersEnabled = false;
                        dot = true;
                    })
                ];

                # Launcher prefixes for the built-in plugins.
                builtInPluginSettings = {
                    dms_qr_generator.trigger = "qrg";
                    dms_power.trigger = "pw";
                    dms_clipboard_search.trigger = "cb";
                    dms_settings_search.trigger = "?";
                };
            };

            dmsSession = {
                configVersion = 7;
                # Random image from the current wallpaper's folder.
                wallpaperCyclingEnabled = true;
                wallpaperCyclingRandom = true;
            };

            # Deep-merges attrs over a JSON file (arrays are replaced whole).
            mergeJson = name: file: attrs: ''
                target="${file}"
                mkdir -p "$(dirname "$target")"
                [ -s "$target" ] || echo '{}' > "$target"
                # On unreadable JSON leave the file alone; DMS reports it itself.
                if jq -s '(.[0] * .[1]) + {configVersion: (.[0].configVersion // .[1].configVersion)}' \
                    "$target" ${pkgs.writeText name (builtins.toJSON attrs)} > "$target.tmp"; then
                    mv "$target.tmp" "$target"
                else
                    rm -f "$target.tmp"
                fi
            '';

            applyDmsSettings = pkgs.writeShellScript "dms-apply-settings" ''
                set -eu
                PATH=${lib.makeBinPath [ pkgs.jq pkgs.coreutils ]}
                ${mergeJson "dms-settings.json" "$HOME/.config/DankMaterialShell/settings.json" dmsSettings}
                ${mergeJson "dms-session.json" "$HOME/.local/state/DankMaterialShell/session.json" dmsSession}
            '';

            # If DMS dies while locked (e.g. a lock-surface protocol error on
            # resume), sway keeps the session locked with nothing drawn: a black
            # screen that eats all input. logind's LockedHint is still set then,
            # so have the restarted DMS put its lock screen back up.
            relockAfterCrash = pkgs.writeShellScript "dms-relock-after-crash" ''
                PATH=${lib.makeBinPath [ pkgs.systemd pkgs.jq pkgs.coreutils ]}
                dms=${config.programs.dank-material-shell.package}/bin/dms
                sid=$(loginctl list-sessions --json=short \
                    | jq -r --arg u "$USER" '.[] | select(.user == $u and .seat != null) | .session' \
                    | head -n1)
                [ -n "$sid" ] || exit 0
                [ "$(loginctl show-session "$sid" -p LockedHint --value)" = yes ] || exit 0
                # The UI takes a few seconds to answer IPC after start, and "lock"
                # succeeds even if sway later refuses the lock, so confirm it took.
                for _ in $(seq 30); do
                    "$dms" ipc call lock lock >/dev/null 2>&1 || true
                    sleep 1
                    [ "$("$dms" ipc call lock isLocked 2>/dev/null)" = true ] && exit 0
                done
            '';
        in
        {
            imports = [ inputs.dms.nixosModules.dank-material-shell ];

            programs.dank-material-shell = {
                enable = true;
                systemd.enable = true;
                systemd.target = "sway-session.target";
                enableAudioWavelength = false;
                enableDynamicTheming = false;
                enableCalendarEvents = false;
            };

            systemd.user.services.dms.serviceConfig = {
                ExecStartPre = [ "${applyDmsSettings}" ];
                ExecStartPost = [ "${relockAfterCrash}" ];
            };

            # The DMS lock screen uses this for passwords and runs fingerprint through
            # its own PAM config, so keep fprintd out of it to avoid a double prompt.
            security.pam.services.dankshell.fprintAuth = false;
        };
}
