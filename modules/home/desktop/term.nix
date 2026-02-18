{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        stylix.targets.kitty.enable = true;
        programs.kitty = {
            enable = true;
            shellIntegration.enableFishIntegration = true;
            settings = {
                allow_remote_control = "yes";
                scrollback_lines = 10000;
                update_check_interval = 0;
                hide_window_decorations = "titlebar-and-corners";
                allow_hyperlinks = "yes";
                open_url_modifiers = "cmd";
                cursor_trail = 100;
                modify_font = "cell_height 165%";
                listen_on = "unix:/tmp/kitty";
                shellIntegration = "enabled";
                enabled_layouts = "tall, splits";
            };
            extraConfig = ''
                # kitty-scrollback.nvim Kitten alias
                action_alias kitty_scrollback_nvim kitten /nix/store/zdairpnlmqa27hwa4wkqmxsw05a18kdf-vim-pack-dir/pack/myNeovimPackages/start/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
                # Browse scrollback buffer in nvim
                map kitty_mod+h kitty_scrollback_nvim
                # Browse output of the last shell command in nvim
                map kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
                # Show clicked command output in nvim
                mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
            '';
            keybindings = let
                prefix = "ctrl+[";
                cmd-runner = pkgs.writeScriptBin "kitty-cmd-runner.sh" ''
                    commands=(
                        "nix switch::cd ~/nix-config; git add .; nh os switch ."
                        "nix gc::sudo nh clean all; nh clean all"
                        "ous bounce::cd ~/ous; ${pkgs.gnumake}/bin/make down; ${pkgs.gnumake}/bin/make platform-up"
                        "ous down::cd ~/ous; ${pkgs.gnumake}/bin/make down"
                        "ous up::cd ~/ous; ${pkgs.gnumake}/bin/make platform-up"
                    )

                    main() {
                        local selected_label
                        selected_label=$(printf '%s\n' "''${commands[@]}" | cut -d':' -f1 | ${pkgs.fzf}/bin/fzf)
                        if [ -z "$selected_label" ]; then
                            exit 0
                        fi
                        local command_to_run
                        local cmd_pair
                        for cmd_pair in "''${commands[@]}"; do
                            if [[ $cmd_pair == "''${selected_label}::"* ]]; then
                                command_to_run="''${cmd_pair#*::}"

                                kitty @ launch --type=window --title "''${selected_label}" ${pkgs.fish}/bin/fish -c "$command_to_run; echo \'\'; echo 'Press Enter to close window...'; read -l"

                                exit 0
                            fi
                        done
                        exit 1
                    }
                    main
                '';
            in {
                "alt+h" = "neighboring_window left";
                "alt+j" = "neighboring_window bottom";
                "alt+k" = "neighboring_window top";
                "alt+l" = "neighboring_window right";
                "${prefix}>c" = "new_tab";
                "${prefix}>k" = "close_tab";
                "${prefix}>n" = "next_tab";
                "${prefix}>p" = "previous_tab";
                "${prefix}>f" = "launch --type=overlay kission";
                "${prefix}>q" = "close_window";
                "${prefix}>v" = "new_window_with_cwd";
                "${prefix}>r" = "load_config_file";
                "${prefix}>e" = "launch --type=overlay ${cmd-runner}/bin/kitty-cmd-runner.sh";
            };
        };
    };
}
