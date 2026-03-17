{
    flake.modules.homeManager.desktop = {
        config,
        pkgs,
        lib,
        ...
    }: let
        fuzzel-cmd-runner = pkgs.writeShellScript "fuzzel-cmd-runner" ''
            commands=(
                "nix rebuild::$HOME/nix-config::git add .; nh os switch ."
                "nix gc::$HOME::sudo nh clean all; nh clean all"
                "ous bounce::$HOME/ous/platform::${pkgs.gnumake}/bin/make bounce"
                "ous down::$HOME/ous/platform::${pkgs.gnumake}/bin/make down"
                "ous up::$HOME/ous/platform::${pkgs.gnumake}/bin/make up"
            )

            selected_label=$(printf '%s\n' "''${commands[@]}" | cut -d':' -f1 | ${pkgs.fuzzel}/bin/fuzzel --dmenu)
            [ -z "$selected_label" ] && exit 0

            for cmd_pair in "''${commands[@]}"; do
                if [[ $cmd_pair == "''${selected_label}::"* ]]; then
                    rest="''${cmd_pair#*::}"
                    cwd="''${rest%%::*}"
                    command_to_run="''${rest#*::}"
                    ${pkgs.foot}/bin/foot -D "$cwd" ${pkgs.fish}/bin/fish -c "$command_to_run; echo; echo 'Press Enter to close...'; read"
                    exit 0
                fi
            done
            exit 1
        '';
    in {
        wayland.windowManager.sway.config = {
            keybindings = let
                mod = "Mod4";
                alt = "Mod1";
                workspace = {
                    a = "workspace 1";
                    s = "workspace 2";
                    d = "workspace 3";
                    f = "workspace 4";
                };
                volume = pkgs.writeShellScriptBin "wp-vol" ''
                    # Get the volume level
                    volume=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@)

                    # Check for mute state
                    if [[ "$volume" == *"[MUTED]" ]]; then
                    	text="Muted"
                    else
                    	text="Volume:"
                    fi

                    # Convert volume level to a percentage
                    volume=$(echo "$volume" | awk '{print $2}')
                    volume=$(echo "( $volume * 100 ) / 1" | ${pkgs.bc}/bin/bc)

                    # Send notification
                    ${pkgs.libnotify}/bin/notify-send -t 1000 -a 'wp-vol' -h string:x-canonical-private-synchronous:volume -h int:value:$volume "$text ''${volume}%"
                '';
                brightness = pkgs.writeShellScriptBin "bctl-notif" ''
                    current="$(${pkgs.brightnessctl}/bin/brightnessctl get)"
                    max="$(${pkgs.brightnessctl}/bin/brightnessctl max)"
                    pct="$(echo "( $current * 100 ) / $max" | ${pkgs.bc}/bin/bc)"

                    ${pkgs.libnotify}/bin/notify-send -t 1000 -a 'brightness' \
                      -h string:x-canonical-private-synchronous:brightness \
                      -h int:value:"$pct" \
                      "Brightness: ''${pct}%"
                '';
                screenshot = pkgs.writeShellScriptBin "screenshot" ''
                    geometry="$1"
                    filename="${config.home.homeDirectory}/Pictures/screenshots/$(date +%s_screenshot.png)"

                    ${pkgs.grim}/bin/grim -g "$geometry" "$filename"

                    ${pkgs.libnotify}/bin/notify-send \
                      -r 71 \
                      -a "Screenshot" \
                      "Screenshot taken" \
                      "$(basename "$filename")" \
                      -t 3000 \
                      -u low \
                      --action="default=Open folder" \
                      --action="open=Open folder"
                '';
                screenrecord = pkgs.writeShellScriptBin "screenrecord" ''
                    RECORDING_PID_FILE="/tmp/wl-screenrec.pid"
                    RECORDING_FILE_FILE="/tmp/wl-screenrec.file"

                    # If already recording, stop it
                    if [ -f "$RECORDING_PID_FILE" ]; then
                        pid=$(cat "$RECORDING_PID_FILE")
                        kill "$pid" 2>/dev/null
                        rm -f "$RECORDING_PID_FILE"
                        recording_file=$(cat "$RECORDING_FILE_FILE" 2>/dev/null)
                        rm -f "$RECORDING_FILE_FILE"
                        ${pkgs.libnotify}/bin/notify-send \
                            -a "Screen Record" \
                            "Recording saved" \
                            "$(basename "$recording_file")" \
                            -t 3000 -u low
                        exit 0
                    fi

                    # Pick mode via fuzzel
                    mode=$(printf 'fullscreen w/ audio\nselected area w/ audio\nfullscreen w/o audio\nselected area w/o audio' \
                        | ${pkgs.fuzzel}/bin/fuzzel --dmenu)
                    [ -z "$mode" ] && exit 0

                    filename="${config.home.homeDirectory}/Videos/recordings/$(date +%s_recording.mp4)"
                    mkdir -p "$(dirname "$filename")"
                    echo "$filename" > "$RECORDING_FILE_FILE"

                    case "$mode" in
                        "fullscreen w/ audio")
                            ${pkgs.wl-screenrec}/bin/wl-screenrec --audio -f "$filename" &
                            ;;
                        "selected area w/ audio")
                            ${pkgs.wl-screenrec}/bin/wl-screenrec --audio -g "$(${pkgs.slurp}/bin/slurp)" -f "$filename" &
                            ;;
                        "fullscreen w/o audio")
                            ${pkgs.wl-screenrec}/bin/wl-screenrec -f "$filename" &
                            ;;
                        "selected area w/o audio")
                            ${pkgs.wl-screenrec}/bin/wl-screenrec -g "$(${pkgs.slurp}/bin/slurp)" -f "$filename" &
                            ;;
                    esac

                    echo $! > "$RECORDING_PID_FILE"
                    ${pkgs.libnotify}/bin/notify-send \
                        -a "Screen Record" \
                        "Recording started" \
                        "$(basename "$filename")" \
                        -t 2000 -u low
                '';
            in
                lib.mkForce {
                    "${mod}+Return" = "exec ${pkgs.foot}/bin/foot";
                    "${mod}+r" = "exec ${pkgs.fuzzel}/bin/fuzzel";
                    "${mod}+e" = "exec ${fuzzel-cmd-runner}";
                    "${mod}+q" = "kill";
                    "${mod}+m" = "fullscreen";

                    "${mod}+a" = workspace.a;
                    "${mod}+s" = workspace.s;
                    "${mod}+d" = workspace.d;
                    "${mod}+f" = workspace.f;

                    "${mod}+Shift+a" = "move container to ${workspace.a}";
                    "${mod}+Shift+s" = "move container to ${workspace.s}";
                    "${mod}+Shift+d" = "move container to ${workspace.d}";
                    "${mod}+Shift+f" = "move container to ${workspace.f}";

                    "${alt}+h" = "focus left";
                    "${alt}+j" = "focus down";
                    "${alt}+k" = "focus up";
                    "${alt}+l" = "focus right";

                    "Shift+Left" = "resize grow width 50px";
                    "Shift+Down" = "resize grow height 50px";
                    "Shift+Up" = "resize shrink height 50px";
                    "Shift+Right" = "resize shrink width 50px";

                    "Ctrl+Shift+3" = "exec ${pkgs.writeShellScript "screenshot-focused-window" ''
                        ${screenshot}/bin/screenshot \
                          "$(${pkgs.sway}/bin/swaymsg -t get_tree \
                          | ${pkgs.jq}/bin/jq -r 'recurse(.nodes[]?, .floating_nodes[]?) | select(.focused) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"')"
                    ''}";
                    "Ctrl+Shift+4" = "exec ${pkgs.writeShellScript "screenshot-area" ''
                        ${screenshot}/bin/screenshot "$(${pkgs.slurp}/bin/slurp)"
                    ''}";
                    "Ctrl+Shift+5" = "exec ${screenrecord}/bin/screenrecord";

                    "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && ${volume}/bin/wp-vol";
                    "XF86AudioLowerVolume " = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ${volume}/bin/wp-vol";
                    "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ${volume}/bin/wp-vol";
                    "XF86AudioMicMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                    "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
                    "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
                    "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
                    "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
                    "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -e4 -n2 set 5%+ && ${brightness}/bin/bctl-notif";
                    "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -e4 -n2 set 5%- && ${brightness}/bin/bctl-notif";
                    "XF86PowerOff" = "exec ${pkgs.wlogout}/bin/wlogout -b 2 -l ${config.xdg.configHome}/wlogout/layout";
                };
        };
    };
}
