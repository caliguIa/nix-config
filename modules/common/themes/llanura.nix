{variant ? "dark"}: let
    # Options: "dark", "light"
    palette = {
        # Base colors from llanura
        background = "#121212";
        alt_background = "#1A1A1A";
        primary = "#ff0088";
        secondary = "#d5d5d5";
        
        # Diagnostic colors
        diagnostic_error = "#9B0837";
        diagnostic_warning = "#FFC857";
        diagnostic_info = "#FFC857";
        diagnostic_hint = "#576CA8";
        
        # Diff colors
        diff_add = "#586935";
        diff_change = "#51657B";
        diff_delete = "#984936";
        diff_add_bg = "#0C4531";
        diff_change_bg = "#10666A";
        diff_delete_bg = "#5C0A14";
        
        # Grayscale palette
        dull_0 = "#ffffff";
        dull_1 = "#f5f5f5";
        dull_2 = "#d5d5d5";
        dull_3 = "#b4b4b4";
        dull_4 = "#a7a7a7";
        dull_5 = "#949494";
        dull_6 = "#737373";
        dull_7 = "#535353";
        dull_8 = "#323232";
        dull_9 = "#212121";
        
        black = "#000000";
        white = "#FFFFFF";
    };

    variantColors = {
        dark = {
            base = palette.background;
            mantle = palette.background;
            crust = palette.background;

            text = palette.dull_3;
            subtext1 = palette.dull_4;
            subtext0 = palette.dull_5;

            overlay2 = palette.dull_6;
            overlay1 = palette.dull_7;
            overlay0 = palette.dull_8;

            surface2 = palette.dull_9;
            surface1 = palette.alt_background;
            surface0 = palette.dull_8;

            blue = palette.diagnostic_hint;
            lavender = palette.primary;
            sapphire = palette.diagnostic_info;
            sky = palette.secondary;
            teal = palette.diagnostic_info;
            green = palette.diff_add;
            yellow = palette.diagnostic_warning;
            peach = palette.diagnostic_warning;
            maroon = palette.diagnostic_error;
            red = palette.diagnostic_error;
            mauve = palette.primary;
            pink = palette.primary;
            flamingo = palette.primary;
            rosewater = palette.secondary;

            terminal = {
                black = palette.dull_9;
                red = palette.diagnostic_error;
                green = palette.diff_add;
                yellow = palette.diagnostic_warning;
                blue = palette.diagnostic_hint;
                magenta = palette.primary;
                cyan = palette.secondary;
                white = palette.dull_3;
                bright_black = palette.dull_7;
                bright_red = palette.primary;
                bright_green = palette.diff_add;
                bright_yellow = palette.diagnostic_warning;
                bright_blue = palette.diagnostic_hint;
                bright_magenta = palette.primary;
                bright_cyan = palette.secondary;
                bright_white = palette.dull_1;
            };
        };

        light = {
            base = palette.dull_0;
            mantle = palette.dull_1;
            crust = palette.dull_2;

            text = palette.dull_9;
            subtext1 = palette.dull_7;
            subtext0 = palette.dull_6;

            overlay2 = palette.dull_5;
            overlay1 = palette.dull_4;
            overlay0 = palette.dull_3;

            surface2 = palette.dull_2;
            surface1 = palette.dull_1;
            surface0 = palette.dull_0;

            blue = palette.diagnostic_hint;
            lavender = palette.primary;
            sapphire = palette.diagnostic_info;
            sky = palette.secondary;
            teal = palette.diagnostic_info;
            green = palette.diff_add;
            yellow = palette.diagnostic_warning;
            peach = palette.diagnostic_warning;
            maroon = palette.diagnostic_error;
            red = palette.diagnostic_error;
            mauve = palette.primary;
            pink = palette.primary;
            flamingo = palette.primary;
            rosewater = palette.secondary;

            terminal = {
                black = palette.dull_9;
                red = palette.diagnostic_error;
                green = palette.diff_add;
                yellow = palette.diagnostic_warning;
                blue = palette.diagnostic_hint;
                magenta = palette.primary;
                cyan = palette.secondary;
                white = palette.dull_3;
                bright_black = palette.dull_7;
                bright_red = palette.primary;
                bright_green = palette.diff_add;
                bright_yellow = palette.diagnostic_warning;
                bright_blue = palette.diagnostic_hint;
                bright_magenta = palette.primary;
                bright_cyan = palette.secondary;
                bright_white = palette.dull_1;
            };
        };
    };

    colors = variantColors.${variant};

    nvimVariantMap = {
        dark = "llanura";
        light = "llanura";
    };
in {
    inherit colors variant;

    nvimColorscheme = nvimVariantMap.${variant};

    starship = rec {
        directory_style = "bold fg:" + colors.blue;
        character_success = "[](" + colors.green + ")";
        character_error = "[](" + colors.red + ")";
        character_vim = "[](" + colors.mauve + ")";
        git_branch_style = "fg:" + colors.lavender;
        git_status_style = colors.overlay0;
        git_state_style = colors.overlay0;
        cmd_duration_style = "fg:" + colors.overlay0;
    };

    tmux = rec {
        status_bg = colors.base;
        status_fg = colors.text;
        window_status_fg = colors.subtext0;
        window_status_current_fg = colors.text;
        pane_border_fg = colors.surface0;
        pane_active_border_fg = colors.blue;
    };

    fzf = rec {
        bg = colors.base;
        bg_plus = colors.surface0;
        preview_bg = colors.base;
        fg = colors.text;
        fg_plus = colors.subtext1;
        preview_fg = colors.text;
        hl = colors.blue;
        hl_plus = colors.blue;
        info = colors.overlay0;
        border = colors.surface0;
        prompt = colors.mauve;
        pointer = colors.green;
        marker = colors.yellow;
        spinner = colors.sapphire;
        header = colors.lavender;
    };
}