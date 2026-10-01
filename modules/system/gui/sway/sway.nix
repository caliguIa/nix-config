{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            programs.sway = {
                enable = true;
                wrapperFeatures.gtk = true;
                # The defaults (swaylock/swayidle/foot/dmenu/pulseaudio) are all
                # replaced by DMS; keep only what our own config execs.
                extraPackages = with pkgs; [
                    wl-clipboard
                    fuzzel
                ];
                extraSessionCommands = ''
                    # qt.* sets these in environment.variables, which systemd units (and
                    # so apps launched from DMS) never see.
                    systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE
                '';
            };

            # xdg-desktop-portal-wlr's screen-share picker: let a person choose an
            # output or a single window via fuzzel instead of always sharing everything.
            xdg.portal.wlr.settings.screencast = {
                chooser_type = "dmenu";
                chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt 'Share: '";
                max_fps = 60;
            };

            # Both portals are UseIn=gnome only. The GNOME file chooser is Nautilus's;
            # GTK's own dialog stays as the fallback.
            xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
            xdg.portal.config.sway = {
                "org.freedesktop.impl.portal.FileChooser" = [
                    "gnome"
                    "gtk"
                ];
                "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            };

            # runXdgAutostartIfNone only covers the X11 "none" session, so sway
            # needs XDG autostart (kdeconnectd etc.) started explicitly.
            systemd.user.targets.sway-session.wants = [ "xdg-desktop-autostart.target" ];
        };
}
