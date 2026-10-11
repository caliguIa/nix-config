{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            programs.sway = {
                enable = true;
                wrapperFeatures.gtk = true;
                # tarr runs the nvidia driver; harmless on other GPUs.
                extraOptions = [ "--unsupported-gpu" ];
                extraPackages = with pkgs; [
                    wl-clipboard
                    fuzzel
                ];
                extraSessionCommands = ''
                    # sway's own config.d only imports XDG_CURRENT_DESKTOP, so systemd units
                    # (and so apps launched from DMS) would otherwise miss the session vars.
                    systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
                '';
            };
            xdg.portal.wlr.settings.screencast = {
                chooser_type = "dmenu";
                chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt 'Share: '";
                max_fps = 60;
            };
            xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
            xdg.portal.config.sway = {
                "org.freedesktop.impl.portal.FileChooser" = [
                    "gnome"
                    "gtk"
                ];
                "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            };
            systemd.user.targets.sway-session.wants = [ "xdg-desktop-autostart.target" ];
        };
}
