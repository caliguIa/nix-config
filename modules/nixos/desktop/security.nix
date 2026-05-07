{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.gnome.gnome-keyring.enable = false;
        security.pam.services.swaylock = {};
        security.pam.services.sudo.fprintAuth = true;
        security.pam.services.login.fprintAuth = false;
        security.pam.services.login.enableGnomeKeyring = false;
        security.pam.services.login.kwallet.enable = true;
        security.pam.services.greetd.enableGnomeKeyring = false;
        security.pam.services.polkit-1.fprintAuth = true;
        security.polkit.enable = true;
        security.polkit.extraConfig = ''
            polkit.addRule(function(action, subject) {
              if (
                subject.isInGroup("users")
                  && (
                    action.id == "org.freedesktop.login1.reboot" ||
                    action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                    action.id == "org.freedesktop.login1.power-off" ||
                    action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                  )
                )
              {
                return polkit.Result.YES;
              }
            });
            polkit.addRule(function(action, subject) {
              if ((action.id == "net.reactivated.fprint.device.enroll" ||
                   action.id == "net.reactivated.fprint.device.setusername" ||
                   action.id == "net.reactivated.fprint.device.verify") &&
                  subject.isInGroup("wheel")) {
                return polkit.Result.YES;
              }
            });
        '';
        systemd = {
            user.services.polkit-gnome-authentication-agent-1 = {
                description = "polkit-gnome-authentication-agent-1";
                wantedBy = ["graphical-session.target"];
                wants = ["graphical-session.target"];
                after = ["graphical-session.target"];
                serviceConfig = {
                    Type = "simple";
                    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                    Restart = "on-failure";
                    RestartSec = 1;
                    TimeoutStopSec = 10;
                };
            };
        };
        environment.systemPackages = with pkgs; [
            polkit
            polkit_gnome
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
