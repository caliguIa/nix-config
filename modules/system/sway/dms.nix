{ inputs, ... }:
{
    flake.modules.nixos.sway =
        { config, pkgs, ... }:
        let
            # DMS defaults to no idle timeouts and no lock before suspend. Seeded once,
            # then owned by DMS's settings UI; missing keys fall back to DMS defaults.
            # Timeouts are seconds; profile names are power-profiles-daemon indices
            # ("0" power-saver, "1" balanced). configVersion skips DMS's migrations.
            dmsSettingsSeed = pkgs.writeText "dms-settings-seed.json" (
                builtins.toJSON {
                    configVersion = 29;

                    acMonitorTimeout = 600; # 10 min
                    acLockTimeout = 600; # 10 min
                    acSuspendTimeout = 0; # never suspend on AC
                    acProfileName = "1"; # balanced

                    batteryMonitorTimeout = 300; # 5 min
                    batteryLockTimeout = 300; # 5 min
                    batterySuspendTimeout = 900; # 15 min
                    batterySuspendBehavior = 0; # 0 = Suspend (not hibernate)
                    batteryProfileName = "0"; # power-saver

                    # Force power-saver below batteryLowThreshold (20%).
                    batteryAutoPowerSaver = true;
                    # Forces 60Hz on battery and re-applies on every output change,
                    # fighting sway's own mode; adaptive sync saves the power instead.
                    lowerDisplayRefreshRateOnBattery = false;

                    lockBeforeSuspend = true;
                    loginctlLockIntegration = true;
                }
            );

            seedDmsSettings = pkgs.writeShellScript "dms-seed-settings" ''
                set -eu
                target="$HOME/.config/DankMaterialShell/settings.json"
                if [ ! -e "$target" ]; then
                    install -Dm644 ${dmsSettingsSeed} "$target"
                fi
            '';

            # The user manager can outlive a sway login into a Plasma one.
            swayRunning = pkgs.writeShellScript "dms-require-sway" ''
                exec ${config.programs.sway.package}/bin/swaymsg -t get_version >/dev/null 2>&1
            '';
        in
        {
            imports = [ inputs.dms.nixosModules.dank-material-shell ];

            programs.dank-material-shell = {
                enable = true;
                systemd.enable = true;
                # Plasma also reaches graphical-session.target (the default here).
                systemd.target = "sway-session.target";
                enableAudioWavelength = false;
                enableDynamicTheming = false;
                enableCalendarEvents = false;
            };

            systemd.user.services.dms.serviceConfig = {
                ExecStartPre = [ "${seedDmsSettings}" ];
                ExecCondition = "${swayRunning}";
            };

            # The DMS lock screen uses this for passwords and runs fingerprint through
            # its own PAM config, so keep fprintd out of it to avoid a double prompt.
            security.pam.services.dankshell.fprintAuth = false;
        };
}
