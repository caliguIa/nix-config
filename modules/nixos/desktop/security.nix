{
    flake.modules.nixos.desktop = {
        pkgs,
        config,
        ...
    }: let
        # Skip fingerprint auth while the laptop lid is closed (clamshell/docked),
        # since the reader is inaccessible. Extracted from the unmerged nixpkgs
        # PR #342676, adapted to the public security.pam rules API.
        # Exits 1 (fail) when any lid reports "closed"; no-op when no lid exists.
        lidClosedScript = pkgs.writeShellScript "fprint-skip-lid-closed" ''
            for f in /proc/acpi/button/lid/*/state; do
                ${pkgs.gnugrep}/bin/grep -q closed "$f" 2>/dev/null && exit 1
            done
            true
        '';
        mkLidSkipRule = service: {
            # Placed just before the built-in fprintd auth rule.
            order = config.security.pam.services.${service}.rules.auth.fprintd.order - 50;
            # Lid closed -> script exits 1 -> "default=1" skips the next module (fprintd).
            # Lid open  -> script exits 0 -> "success=ignore" falls through to fprintd.
            control = "[success=ignore default=1]";
            modulePath = "${pkgs.linux-pam}/lib/security/pam_exec.so";
            args = ["quiet" "${lidClosedScript}"];
        };
    in {
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.sudo.fprintAuth = true;
        security.pam.services.polkit-1.fprintAuth = true;
        security.pam.services.sudo.rules.auth.fprintd-lid = mkLidSkipRule "sudo";
        security.pam.services.polkit-1.rules.auth.fprintd-lid = mkLidSkipRule "polkit-1";
        security.pam.services.login.enableGnomeKeyring = true;
        security.polkit.enable = true;
        environment.systemPackages = with pkgs; [
            polkit
            seahorse
        ];
        environment.etc."polkit-1/actions/com.bitwarden.Bitwarden.policy" = {
            text = ''
                <?xml version="1.0" encoding="UTF-8"?>
                <!DOCTYPE policyconfig PUBLIC
                 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
                 "http://www.freedesktop.org/standards/PolicyKit/1.0/policyconfig.dtd">

                <policyconfig>
                    <action id="com.bitwarden.Bitwarden.unlock">
                      <description>Unlock Bitwarden</description>
                      <message>Authenticate to unlock Bitwarden</message>
                      <defaults>
                        <allow_any>no</allow_any>
                        <allow_inactive>no</allow_inactive>
                        <allow_active>auth_self</allow_active>
                      </defaults>
                    </action>
                </policyconfig>
            '';
            mode = "0644";
        };
    };
}
