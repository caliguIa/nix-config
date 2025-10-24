{variant ? "dark"}: let
    # Options: "dark", "light"
    palette = {
        normal_bg = "#191d23";
        panel_bg = "#1B1F25";
        float_bg = "#1C2127";
        normal_bg_alt = "#20252E";
        normal_bg_accent = "#242932";
        float_bg_border = "#2A2F39";
        float_bg_select = "#1F242D";

        normal_fg = "#CCD5E5";
        float_fg = "#D6DDEA";
        nontext_fg = "#363848";
        comment_fg = "#474B65";
        quote_fg = "#7E8193";

        v_select = "#13214B";
        v_select_nontext = "#32416F";
        string = "#74BAA8";
        raw_string = "#0EC256";
        cursor = "#5DCD9A";
        operator = "#b09884";
        constant = "#BCB6EC";
        keyword = "#A9B9EF";
        important = "#6A8BE3";
        search = "#E9B872";
        number = "#B85B53";

        info = "#1A8C9B";
        warn = "#FFA630";
        error = "#F71735";

        git_add_fg = "#9FDACC";
        git_add_bg = "#1E3A34";
        git_delete_fg = "#FFC0C5";
        git_delete_bg = "#3A1A21";
        git_change_fg = "#B7C4FF";
        git_change_bg = "#1F2B5C";

        black = "#000000";
        white = "#FFFFFF";
    };

    variantColours = {
        dark = {
            base = palette.normal_bg;
            mantle = palette.panel_bg;
            crust = palette.float_bg;

            text = palette.normal_fg;
            subtext1 = palette.float_fg;
            subtext0 = palette.quote_fg;

            overlay2 = palette.comment_fg;
            overlay1 = palette.nontext_fg;
            overlay0 = palette.comment_fg;

            surface2 = palette.normal_bg_alt;
            surface1 = palette.normal_bg_accent;
            surface0 = palette.float_bg_border;

            blue = palette.important;
            lavender = palette.constant;
            sapphire = palette.info;
            sky = palette.keyword;
            teal = palette.string;
            green = palette.cursor;
            yellow = palette.search;
            peach = palette.warn;
            maroon = palette.error;
            red = palette.error;
            mauve = palette.constant;
            pink = palette.number;
            flamingo = palette.operator;
            rosewater = palette.raw_string;

            terminal = {
                black = palette.black;
                red = palette.error;
                green = palette.cursor;
                yellow = palette.search;
                blue = palette.important;
                magenta = palette.constant;
                cyan = palette.string;
                white = palette.normal_fg;
                bright_black = palette.comment_fg;
                bright_red = palette.error;
                bright_green = palette.cursor;
                bright_yellow = palette.warn;
                bright_blue = palette.keyword;
                bright_magenta = palette.constant;
                bright_cyan = palette.info;
                bright_white = palette.white;
            };
        };

        light = {
            base = "#E8EDF5";
            mantle = "#E4E9F1";
            crust = "#E0E5ED";

            text = "#2A3138";
            subtext1 = "#323942";
            subtext0 = "#474B65";

            overlay2 = "#7E8193";
            overlay1 = "#9CA0B0";
            overlay0 = "#B8BCC8";

            surface2 = "#D0D5DD";
            surface1 = "#D6DDEA";
            surface0 = "#CCD5E5";

            blue = "#4C6B96";
            lavender = "#8A7EC5";
            sapphire = "#1A6B7A";
            sky = "#7A8BAF";
            teal = "#5A8B7A";
            green = "#4A7A5A";
            yellow = "#C8A830";
            peach = "#D6743F";
            maroon = "#C73755";
            red = "#C73755";
            mauve = "#8A7EC5";
            pink = "#A85B73";
            flamingo = "#9A7B64";
            rosewater = "#0CA236";

            terminal = {
                black = palette.black;
                red = palette.error;
                green = palette.cursor;
                yellow = palette.search;
                blue = palette.important;
                magenta = palette.constant;
                cyan = palette.string;
                white = palette.normal_fg;
                bright_black = palette.comment_fg;
                bright_red = palette.error;
                bright_green = palette.cursor;
                bright_yellow = palette.warn;
                bright_blue = palette.keyword;
                bright_magenta = palette.constant;
                bright_cyan = palette.info;
                bright_white = palette.white;
            };
        };
    };

    colours = variantColours.${variant};

    nvimVariantMap = {
        dark = "techbase";
        light = "techbase";
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

