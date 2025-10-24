{variant ? "dark"}: let
    # Options: "dark", "light"
    palette = {
        background = "#121212";
        alt_background = "#1A1A1A";
        primary = "#ff0088";
        secondary = "#d5d5d5";

        diagnostic_error = "#9B0837";
        diagnostic_warning = "#FFC857";
        diagnostic_info = "#FFC857";
        diagnostic_hint = "#576CA8";

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

    variantColours = {
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

    colours = variantColours.${variant};

    nvimVariantMap = {
        dark = "llanura";
        light = "llanura";
    };
in {
    inherit colours variant;

    nvimColourscheme = nvimVariantMap.${variant};

    starship = rec {
        directory_style = "bold fg:" + colours.blue;
        character_success = "[](" + colours.green + ")";
        character_error = "[](" + colours.red + ")";
        character_vim = "[](" + colours.mauve + ")";
        git_branch_style = "fg:" + colours.lavender;
        git_status_style = colours.overlay0;
        git_state_style = colours.overlay0;
        cmd_duration_style = "fg:" + colours.overlay0;
    };

    tmux = rec {
        status_bg = colours.base;
        status_fg = colours.text;
        window_status_fg = colours.subtext0;
        window_status_current_fg = colours.text;
        pane_border_fg = colours.surface0;
        pane_active_border_fg = colours.blue;
    };

    fzf = rec {
        bg = colours.base;
        bg_plus = colours.surface0;
        preview_bg = colours.base;
        fg = colours.text;
        fg_plus = colours.subtext1;
        preview_fg = colours.text;
        hl = colours.blue;
        hl_plus = colours.blue;
        info = colours.overlay0;
        border = colours.surface0;
        prompt = colours.mauve;
        pointer = colours.green;
        marker = colours.yellow;
        spinner = colours.sapphire;
        header = colours.lavender;
    };
}

