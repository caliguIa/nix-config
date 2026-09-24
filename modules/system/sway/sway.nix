{
    flake.modules.nixos.sway =
        { pkgs, ... }:
        {
            programs.sway = {
                enable = true;
                wrapperFeatures.gtk = true;
                # The defaults (swaylock/swayidle/foot/dmenu/pulseaudio) are all
                # replaced by DMS; keep only what our own config execs.
                extraPackages = with pkgs; [
                    wl-clipboard
                    grim
                    slurp
                    fuzzel
                ];
                # The user manager can outlive a Plasma login; drop its KDE env.
                extraSessionCommands = ''
                    export QT_QPA_PLATFORMTHEME=kde
                    systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE QT_QPA_PLATFORMTHEME
                    systemctl --user unset-environment KDE_FULL_SESSION KDE_SESSION_VERSION KDE_SESSION_UID KDE_APPLICATIONS_AS_SCOPE
                '';
            };

            # xdg-desktop-portal-wlr's screen-share picker: let a person choose an
            # output or a single window via fuzzel instead of always sharing everything.
            xdg.portal.wlr.settings.screencast = {
                chooser_type = "dmenu";
                chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt 'Share: '";
                max_fps = 60;
            };

            # kwallet.portal is UseIn=kde only.
            xdg.portal.config.sway."org.freedesktop.impl.portal.Secret" = [ "kwallet" ];

            # runXdgAutostartIfNone only covers the X11 "none" session, so sway
            # needs XDG autostart (kdeconnectd etc.) started explicitly.
            systemd.user.targets.sway-session.wants = [ "xdg-desktop-autostart.target" ];
        };
}
