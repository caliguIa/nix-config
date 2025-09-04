{pkgs, ...}: {
    programs.kitty = {
        enable = true;
        font = {
            name = "Berkeley Mono";
            size = 14;
        };
        shellIntegration.enableFishIntegration = true;
        settings = {
            hide_window_decorations = true;
            window_padding_width = 0;
            cursor_shape = "beam";
            scrollback_lines = 10000;
            enable_audio_bell = false;
            update_check_interval = 0;
            close_on_child_death = true;
            macos_option_as_alt = true;
            confirm_os_window_close = 0;
            modify_font = "cell_height 165%";
            cursor_trail = 2;
            cursor_blink_interval = "0.5 ease-in-out";
        };
    };
}
