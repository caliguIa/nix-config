{
    flake.modules.hjem.sway =
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
            xdg.config.files."sway/config".text = ''
                set $mod Mod4

                output eDP-1 scale 1.0 mode 2560x1600@165Hz adaptive_sync on

                # Clamshell: logind won't suspend while docked, so blank the closed panel.
                bindswitch --reload --locked lid:on exec ${lidClosed}
                bindswitch --reload --locked lid:off exec ${lidOpened}
                exec ${outputWatcher}

                input type:touchpad {
                    natural_scroll enabled
                    tap disabled
                    click_method clickfinger
                    dwt enabled
                }

                input type:keyboard {
                    xkb_layout gb
                }

                default_border pixel 2
                default_floating_border pixel 2
                hide_edge_borders smart
                floating_modifier $mod normal

                # Workspaces (matches the 4 desktops used under Plasma).
                bindsym $mod+a workspace number 1
                bindsym $mod+s workspace number 2
                bindsym $mod+d workspace number 3
                bindsym $mod+f workspace number 4
                bindsym $mod+Shift+a move container to workspace number 1
                bindsym $mod+Shift+s move container to workspace number 2
                bindsym $mod+Shift+d move container to workspace number 3
                bindsym $mod+Shift+f move container to workspace number 4

                # keyd turns Meta+h/j/k/l into bare arrows, so these need the
                # physical arrow keys.
                bindsym $mod+Left focus left
                bindsym $mod+Down focus down
                bindsym $mod+Up focus up
                bindsym $mod+Right focus right
                bindsym $mod+Shift+Left move left
                bindsym $mod+Shift+Down move down
                bindsym $mod+Shift+Up move up
                bindsym $mod+Shift+Right move right

                bindsym $mod+m fullscreen toggle
                bindsym $mod+r exec dms ipc call spotlight toggle
                bindsym $mod+Return exec ghostty
                bindsym $mod+q kill

                bindsym $mod+backslash splith
                bindsym $mod+minus splitv
                bindsym $mod+t layout toggle tabbed split
                bindsym $mod+Shift+space floating toggle
                bindsym $mod+Shift+c reload
                bindsym $mod+Shift+e exec swaynag -t warning -m 'Exit sway?' -B 'Exit' 'swaymsg exit'
                # Fallback launcher if DMS itself is down.
                bindsym $mod+Shift+Return exec fuzzel

                mode "resize" {
                    bindsym Left resize shrink width 10px
                    bindsym Down resize grow height 10px
                    bindsym Up resize shrink height 10px
                    bindsym Right resize grow width 10px
                    bindsym Escape mode "default"
                    bindsym Return mode "default"
                }
                bindsym $mod+Shift+r mode "resize"

                # DMS
                bindsym $mod+n exec dms ipc call notifications toggle
                bindsym $mod+comma exec dms ipc call settings focusOrToggle
                bindsym $mod+x exec dms ipc call powermenu toggle
                bindsym $mod+Escape exec dms ipc call lock lock
                bindsym $mod+Shift+v exec dms ipc call clipboard toggle
                bindsym Ctrl+Alt+Delete exec dms ipc call processlist focusOrToggle
                bindsym $mod+Shift+slash exec dms ipc call keybinds toggle sway

                # Media / brightness keys, active even while locked.
                bindsym --locked XF86AudioRaiseVolume exec dms ipc call audio increment 3
                bindsym --locked XF86AudioLowerVolume exec dms ipc call audio decrement 3
                bindsym --locked XF86AudioMute exec dms ipc call audio mute
                bindsym --locked XF86AudioMicMute exec dms ipc call audio micmute
                bindsym --locked XF86AudioPlay exec dms ipc call mpris playPause
                bindsym --locked XF86AudioPause exec dms ipc call mpris playPause
                bindsym --locked XF86AudioNext exec dms ipc call mpris next
                bindsym --locked XF86AudioPrev exec dms ipc call mpris previous
                bindsym --locked XF86MonBrightnessUp exec dms ipc call brightness increment 5 "backlight:amdgpu_bl1"
                bindsym --locked XF86MonBrightnessDown exec dms ipc call brightness decrement 5 "backlight:amdgpu_bl1"

                # Screenshots: saved to a file and copied to the clipboard.
                bindsym Print exec dms screenshot region
                bindsym Ctrl+Shift+4 exec dms screenshot region
                bindsym Ctrl+Shift+3 exec dms screenshot full
                # Start/stop; the portal picker asks what to record.
                bindsym Ctrl+Shift+5 exec dms ipc call screenRecorder toggleRecording

                # Unlock KWallet with the login password, same as Plasma's PAM hook does.
                exec ${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init

                # DMS itself starts via its systemd user unit, bound to sway-session.target.
                include /etc/sway/config.d/*
            '';
        };
}
