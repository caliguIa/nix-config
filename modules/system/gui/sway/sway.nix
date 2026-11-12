{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        let
            # Slack's own source picker polls the portal every ~2s for fresh
            # thumbnails, and each poll is a new ScreenCast session that runs
            # the chooser again. Hand the last pick back to any request that
            # arrives within 10s of the previous one; the window slides while
            # the polling continues and lapses once it stops. Cancels aren't kept.
            shareChooser = pkgs.writeShellApplication {
                name = "share-chooser";
                runtimeInputs = [ pkgs.coreutils ];
                text = ''
                    cache="''${XDG_RUNTIME_DIR:?}/share-chooser-last"
                    if [ -s "$cache" ] && [ $(($(date +%s) - $(stat -c %Y "$cache"))) -lt 10 ]; then
                        touch "$cache"
                        cat "$cache"
                        exit 0
                    fi
                    rm -f "$cache"
                    pick=$(${pkgs.wlr-utils}/bin/wlr-chooser "$@") || true
                    [ -n "$pick" ] || exit 1
                    printf '%s\n' "$pick" > "$cache"
                    printf '%s\n' "$pick"
                '';
            };
        in
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
            # wlr-chooser: overlay grid of live screen and window thumbnails
            # (window capture needs sway >= 1.12). It prints xdpw's
            # "Monitor: …"/"Window: …" line itself, hence the simple type.
            xdg.portal.wlr.settings.screencast = {
                chooser_type = "simple";
                chooser_cmd = "${shareChooser}/bin/share-chooser";
                max_fps = 60;
            };
            # Chromium/Electron (Slack) opens a fresh portal session for every
            # source-list refresh and again to start the share, so xdpw would
            # rerun the chooser each time. Granting restore tokens lets the
            # follow-ups reuse the pick; "transient" lasts only while the app runs.
            systemd.user.services.xdg-desktop-portal-wlr.environment.XDPW_PERSIST_MODE = "transient";
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
