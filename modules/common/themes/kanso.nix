{variant ? "ink"}: let
    # Options: "ink", "pearl", "zen"
    palette = {
        zen0 = "#090E13";
        zen1 = "#1C1E25";
        zen2 = "#23252D";
        zen3 = "#393B44";

        zenBlue1 = "#223249";
        zenBlue2 = "#2D4F67";

        winterGreen = "#2B3328";
        winterYellow = "#49443C";
        winterRed = "#43242B";
        winterBlue = "#252535";
        autumnGreen = "#76946A";
        autumnRed = "#C34043";
        autumnYellow = "#DCA561";

        samuraiRed = "#C34043";
        roninYellow = "#DCA561";
        zenAqua1 = "#6A9589";
        inkBlue = "#658594";

        oldWhite = "#C5C9C7";
        fujiWhite = "#f2f1ef";

        springViolet1 = "#938AA9";
        springBlue = "#7FB4CA";
        zenAqua2 = "#7AA89F";

        springGreen = "#98BB6C";
        carpYellow = "#E6C384";

        zenRed = "#E46876";
        katanaGray = "#717C7C";

        inkBlack0 = "#14171d";
        inkBlack1 = "#1f1f26";
        inkBlack2 = "#23252D";
        inkBlack3 = "#393B44";
        inkBlack4 = "#4b4e57";

        inkWhite = "#C5C9C7";
        inkGreen = "#87a987";
        inkGreen2 = "#8a9a7b";
        inkPink = "#a292a3";
        inkOrange = "#b6927b";
        inkOrange2 = "#b98d7b";
        inkGray = "#A4A7A4";
        inkGray1 = "#909398";
        inkGray2 = "#75797f";
        inkGray3 = "#5C6066";
        inkBlue2 = "#8ba4b0";
        inkViolet = "#8992a7";
        inkRed = "#c4746e";
        inkAqua = "#8ea4a2";
        inkAsh = "#5C6066";
        inkTeal = "#949fb5";
        inkYellow = "#c4b28a";

        mist0 = "#313238";
        mist1 = "#2a2c35";
        mist2 = "#43464E";
        mist3 = "#5C6066";

        mistWhite = "#C5C9C7";
        mistGreen = "#87a987";
        mistGreen2 = "#8a9a7b";
        mistPink = "#a292a3";
        mistOrange = "#b6927b";
        mistOrange2 = "#b98d7b";
        mistGray = "#A4A7A4";
        mistGray1 = "#909398";
        mistGray2 = "#75797f";
        mistGray3 = "#5C6066";
        mistBlue2 = "#8ba4b0";
        mistViolet = "#8992a7";
        mistRed = "#c4746e";
        mistAqua = "#8ea4a2";
        mistAsh = "#5C6066";
        mistTeal = "#949fb5";
        mistYellow = "#c4b28a";

        pearlInk0 = "#23252D";
        pearlInk1 = "#545464";
        pearlInk2 = "#43436c";
        pearlGray = "#e2e1df";
        pearlGray2 = "#5C6068";
        pearlGray3 = "#6D6D69";
        pearlGray4 = "#9F9F99";

        pearlWhite0 = "#f2f1ef";
        pearlWhite1 = "#e2e1df";
        pearlWhite2 = "#dddddb";
        pearlWhite3 = "#cacac7";
        pearlViolet1 = "#a09cac";
        pearlViolet2 = "#766b90";
        pearlViolet3 = "#c9cbd1";
        pearlViolet4 = "#624c83";
        pearlBlue1 = "#c7d7e0";
        pearlBlue2 = "#b5cbd2";
        pearlBlue3 = "#9fb5c9";
        pearlBlue4 = "#4d699b";
        pearlBlue5 = "#5d57a3";
        pearlGreen = "#6f894e";
        pearlGreen2 = "#6e915f";
        pearlGreen3 = "#b7d0ae";
        pearlPink = "#b35b79";
        pearlOrange = "#cc6d00";
        pearlOrange2 = "#e98a00";
        pearlYellow = "#77713f";
        pearlYellow2 = "#836f4a";
        pearlYellow3 = "#de9800";
        pearlYellow4 = "#f9d791";
        pearlRed = "#c84053";
        pearlRed2 = "#d7474b";
        pearlRed3 = "#e82424";
        pearlRed4 = "#d9a594";
        pearlAqua = "#597b75";
        pearlAqua2 = "#5e857a";
        pearlTeal1 = "#4e8ca2";
        pearlTeal2 = "#6693bf";
        pearlTeal3 = "#5a7785";
        pearlCyan = "#d7e3d8";
    };

    variantColors = {
        ink = {
            base = palette.inkBlack0;
            mantle = palette.inkBlack0;
            crust = palette.inkBlack0;

            text = palette.inkWhite;
            subtext1 = palette.inkGray1;
            subtext0 = palette.inkGray2;

            overlay2 = palette.inkGray3;
            overlay1 = palette.inkAsh;
            overlay0 = palette.inkGray3;

            surface2 = palette.inkBlack4;
            surface1 = palette.inkBlack3;
            surface0 = palette.inkBlack2;

            blue = palette.inkBlue2;
            lavender = palette.inkViolet;
            sapphire = palette.inkTeal;
            sky = palette.inkAqua;
            teal = palette.inkTeal;
            green = palette.inkGreen;
            yellow = palette.inkYellow;
            peach = palette.inkOrange;
            maroon = palette.inkRed;
            red = palette.inkRed;
            mauve = palette.inkViolet;
            pink = palette.inkPink;
            flamingo = palette.inkPink;
            rosewater = palette.inkPink;

            terminal = {
                black = palette.inkBlack2;
                red = palette.inkRed;
                green = palette.inkGreen;
                yellow = palette.inkYellow;
                blue = palette.inkBlue2;
                magenta = palette.inkViolet;
                cyan = palette.inkAqua;
                white = palette.inkGray;
                bright_black = palette.inkGray3;
                bright_red = palette.inkRed;
                bright_green = palette.inkGreen2;
                bright_yellow = palette.inkYellow;
                bright_blue = palette.inkBlue2;
                bright_magenta = palette.inkViolet;
                bright_cyan = palette.inkAqua;
                bright_white = palette.inkWhite;
            };
        };

        pearl = {
            base = palette.pearlWhite0;
            mantle = palette.pearlWhite1;
            crust = palette.pearlWhite2;

            text = palette.pearlInk0;
            subtext1 = palette.pearlGray2;
            subtext0 = palette.pearlGray3;

            overlay2 = palette.pearlGray4;
            overlay1 = palette.pearlViolet1;
            overlay0 = palette.pearlGray3;

            surface2 = palette.pearlWhite3;
            surface1 = palette.pearlWhite2;
            surface0 = palette.pearlWhite1;

            blue = palette.pearlBlue4;
            lavender = palette.pearlViolet2;
            sapphire = palette.pearlTeal1;
            sky = palette.pearlTeal2;
            teal = palette.pearlTeal3;
            green = palette.pearlGreen2;
            yellow = palette.pearlYellow2;
            peach = palette.pearlOrange2;
            maroon = palette.pearlRed2;
            red = palette.pearlRed;
            mauve = palette.pearlViolet4;
            pink = palette.pearlPink;
            flamingo = palette.pearlPink;
            rosewater = palette.pearlRed4;

            terminal = {
                black = palette.pearlInk0;
                red = palette.pearlRed;
                green = palette.pearlGreen;
                yellow = palette.pearlYellow;
                blue = palette.pearlBlue4;
                magenta = palette.pearlViolet4;
                cyan = palette.pearlAqua;
                white = palette.pearlGray;
                bright_black = palette.pearlGray2;
                bright_red = palette.pearlRed2;
                bright_green = palette.pearlGreen2;
                bright_yellow = palette.pearlYellow3;
                bright_blue = palette.pearlBlue5;
                bright_magenta = palette.pearlViolet2;
                bright_cyan = palette.pearlAqua2;
                bright_white = palette.pearlWhite0;
            };
        };

        zen = {
            base = palette.zen0;
            mantle = palette.zen0;
            crust = palette.zen0;

            text = palette.fujiWhite;
            subtext1 = palette.oldWhite;
            subtext0 = palette.katanaGray;

            overlay2 = palette.zen3;
            overlay1 = palette.zen2;
            overlay0 = palette.zen3;

            surface2 = palette.zen3;
            surface1 = palette.zen2;
            surface0 = palette.zen1;

            blue = palette.springBlue;
            lavender = palette.springViolet1;
            sapphire = palette.zenAqua1;
            sky = palette.zenAqua2;
            teal = palette.zenAqua1;
            green = palette.springGreen;
            yellow = palette.carpYellow;
            peach = palette.autumnYellow;
            maroon = palette.zenRed;
            red = palette.autumnRed;
            mauve = palette.springViolet1;
            pink = palette.zenRed;
            flamingo = palette.zenRed;
            rosewater = palette.zenRed;

            terminal = {
                black = palette.zen2;
                red = palette.autumnRed;
                green = palette.springGreen;
                yellow = palette.carpYellow;
                blue = palette.springBlue;
                magenta = palette.springViolet1;
                cyan = palette.zenAqua2;
                white = palette.oldWhite;
                bright_black = palette.zen3;
                bright_red = palette.zenRed;
                bright_green = palette.autumnGreen;
                bright_yellow = palette.roninYellow;
                bright_blue = palette.springBlue;
                bright_magenta = palette.springViolet1;
                bright_cyan = palette.zenAqua1;
                bright_white = palette.fujiWhite;
            };
        };
    };

    colors = variantColors.${variant};

    nvimVariantMap = {
        ink = "kanso";
        pearl = "kanso";
        zen = "kanso-zen";
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
