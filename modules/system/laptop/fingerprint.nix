{
    flake.modules.nixos.laptop =
        {
            pkgs,
            config,
            ...
        }:
        let
            # Skip fingerprint auth while the laptop lid is closed (clamshell/docked)
            # Extracted from the unmerged nixpkgs PR #342676,
            lidClosedScript = pkgs.writeShellScript "fprint-skip-lid-closed" ''
                for f in /proc/acpi/button/lid/*/state; do
                    ${pkgs.gnugrep}/bin/grep -q closed "$f" 2>/dev/null && exit 1
                done
                true
            '';
            mkLidSkipRule = service: {
                order = config.security.pam.services.${service}.rules.auth.fprintd.order - 50;
                control = "[success=ignore default=1]";
                modulePath = "${pkgs.linux-pam}/lib/security/pam_exec.so";
                args = [
                    "quiet"
                    "${lidClosedScript}"
                ];
            };
        in
        {
            security.pam.services.sudo.fprintAuth = true;
            security.pam.services.polkit-1.fprintAuth = true;
            security.pam.services.sudo.rules.auth.fprintd-lid = mkLidSkipRule "sudo";
            security.pam.services.polkit-1.rules.auth.fprintd-lid = mkLidSkipRule "polkit-1";
        };
}
