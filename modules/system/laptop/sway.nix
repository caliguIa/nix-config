{
    flake.modules.hjem.laptop =
        { pkgs, ... }:
        let
            # Only blank the closed panel when docked. Undocked, logind suspends
            # anyway, and dropping/re-adding eDP-1 under the DMS lock screen makes
            # its lock surface commit a stale size on resume; sway kills it for the
            # protocol error and the session stays locked on a black screen.
            lidClosed = pkgs.writeShellScript "sway-lid-closed" ''
                if swaymsg -t get_outputs \
                    | ${pkgs.jq}/bin/jq -e 'any(.[]; .name != "eDP-1" and .active)' >/dev/null; then
                    swaymsg output eDP-1 disable
                fi
            '';
            lidOpened = pkgs.writeShellScript "sway-lid-opened" ''
                if swaymsg -t get_outputs \
                    | ${pkgs.jq}/bin/jq -e 'any(.[]; .name == "eDP-1" and (.active | not))' >/dev/null; then
                    swaymsg output eDP-1 enable
                fi
            '';
            # Docking/undocking with the lid already shut fires no lid event: bring
            # the panel back as soon as it'd be the only output (before logind
            # suspends and DMS locks), and blank it when docking with the lid shut.
            outputWatcher = pkgs.writeShellScript "sway-edp-watcher" ''
                jq=${pkgs.jq}/bin/jq
                swaymsg -t subscribe -m '["output"]' | while read -r _; do
                    outs=$(swaymsg -t get_outputs) || continue
                    others=$($jq 'any(.[]; .name != "eDP-1" and .active)' <<<"$outs")
                    edp=$($jq -r '.[] | select(.name == "eDP-1") | .active' <<<"$outs")
                    if [ "$others" = false ] && [ "$edp" = false ]; then
                        swaymsg output eDP-1 enable
                    elif [ "$others" = true ] && [ "$edp" = true ] \
                        && grep -qs closed /proc/acpi/button/lid/*/state; then
                        swaymsg output eDP-1 disable
                    fi
                done
            '';
        in
        {
            # Clamshell: logind won't suspend while docked, so blank the closed panel.
            xdg.config.files."sway/config.d/laptop.conf".text = ''
                bindswitch --reload --locked lid:on exec ${lidClosed}
                bindswitch --reload --locked lid:off exec ${lidOpened}
                exec ${outputWatcher}
            '';
        };
}
