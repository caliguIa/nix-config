{
    flake.modules.homeManager.desktop = {pkgs, ...}: {
        stylix.targets.kitty.enable = true;
        programs.kitty = {
            enable = true;
            shellIntegration.enableFishIntegration = true;
            settings = {
                # allow_remote_control = "yes";
                scrollback_lines = 10000;
                update_check_interval = 0;
                macos_quit_when_last_window_closed = "yes";
                macos_show_window_title_in = "none";
                macos_colorspace = "default";
                hide_window_decorations = "titlebar-and-corners";
                allow_hyperlinks = "yes";
                open_url_modifiers = "cmd";
                cursor_trail = 100;
                modify_font = "cell_height 165%";
            };
            keybindings = let
                prefix = "ctrl+[";
                sessionOus = pkgs.writeTextFile {
                    name = "ous.kitty-session";
                    text = ''
                        layout splits
                        cd ~/ous
                        launch --title "ous"
                    '';
                };
                sessionNixConfig = pkgs.writeTextFile {
                    name = "nix-config.kitty-session";
                    text = ''
                        layout splits
                        cd ~/nix-config
                        launch --title "nix-config" --bias 75 nvim
                        launch
                    '';
                };
                # cmd-runner = pkgs.writeScriptBin "kitty-cmd-runner.sh" ''
                #     commands=(
                #         "nix switch::cd ~/nix-config; ${pkgs.just}/bin/just switch"
                #         "nix build::cd ~/nix-config; ${pkgs.just}/bin/just build"
                #         "nix update::cd ~/nix-config; ${pkgs.just}/bin/just update"
                #         "nix gc::sudo nh clean all; nh clean all"
                #         "ous bounce::cd ~/ous; make down; make platform-up"
                #         "ous down::cd ~/ous; make down"
                #         "ous up::cd ~/ous; make platform-up"
                #         "pr review::prr-review.sh"
                #     )
                #
                #     main() {
                #         local selected_label
                #         selected_label=$(printf '%s\n' "''${commands[@]}" | cut -d':' -f1 | ${pkgs.fzf}/bin/fzf)
                #         if [ -z "$selected_label" ]; then
                #             exit 0
                #         fi
                #         local command_to_run
                #         local cmd_pair
                #         for cmd_pair in "''${commands[@]}"; do
                #             if [[ $cmd_pair == "''${selected_label}::"* ]]; then
                #                 command_to_run="''${cmd_pair#*::}"
                #                 local full_shell_command
                #                 full_shell_command="
                #                     echo \"Running: ''${command_to_run}\"
                #                     eval \"''${command_to_run}\"
                #                     echo 'Press Enter to close window...'
                #                     read -r
                #                 "
                #
                #                 kitty @ launch \
                #                     --type=window \
                #                     --title "''${selected_label}" \
                #                     # sh -c "${pkgs.fish}/fish -ic \"''${full_shell_command}"\"
                #
                #                 exit 0
                #             fi
                #         done
                #         exit 1
                #     }
                #     main
                # '';
            in {
                "alt+h" = "neighboring_window left";
                "alt+j" = "neighboring_window bottom";
                "alt+k" = "neighboring_window top";
                "alt+l" = "neighboring_window right";
                "${prefix}>c" = "new_tab";
                "${prefix}>k" = "close_tab";
                "${prefix}>n" = "next_tab";
                "${prefix}>p" = "previous_tab";
                "${prefix}>f" = "goto_session";
                "${prefix}>1" = "goto_session ${sessionOus}";
                "${prefix}>2" = "goto_session ${sessionNixConfig}";
                "${prefix}>q" = "close_window";
                "${prefix}>v" = "new_window_with_cwd";
                "${prefix}>r" = "load_config_file";
                # "ctrl+space>e" = "launch --type=overlay ${cmd-runner}/bin/kitty-cmd-runner.sh";
            };
        };
    };
}
