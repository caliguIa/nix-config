local M = {}

local colors = {
    fg = "#E1E1E1",
    bg = "#151515",
    alt_bg = "#171717",
    accent = "#202020",
    white = "#E1E1E1",
    gray = "#373737",
    medium_gray = "#727272",
    light_gray = "#AFAFAF",
    blue = "#BAD7FF",
    gray_blue = "#7E97AB",
    medium_gray_blue = "#A2B5C1",
    cyan = "#88afa2",
    red = "#b46958",
    green = "#90A959",
    yellow = "#F4BF75",
    orange = "#FFA557",
    purple = "#AA749F",
    magenta = "#AA759F",
    cursor_fg = "#151515",
    cursor_bg = "#D0D0D0",
}

function M.get_theme()
    return {
        -- Terminal colors
        foreground = colors.fg,
        background = colors.bg,

        -- Cursor colors
        cursor_fg = colors.cursor_fg,
        cursor_bg = colors.cursor_bg,
        cursor_border = colors.cursor_bg,

        -- Selection colors
        selection_fg = colors.fg,
        selection_bg = colors.accent,

        -- Scrollbar
        scrollbar_thumb = colors.gray,

        -- Split color
        split = colors.gray,

        -- Basic ANSI colors
        ansi = {
            colors.gray, -- Black
            colors.red, -- Red
            colors.green, -- Green
            colors.yellow, -- Yellow
            colors.blue, -- Blue
            colors.magenta, -- Magenta
            colors.cyan, -- Cyan
            colors.white, -- White
        },

        -- Bright ANSI colors
        brights = {
            colors.medium_gray, -- Bright Black
            colors.red, -- Bright Red
            colors.green, -- Bright Green
            colors.yellow, -- Bright Yellow
            colors.blue, -- Bright Blue
            colors.magenta, -- Bright Magenta
            colors.cyan, -- Bright Cyan
            colors.white, -- Bright White
        },

        -- Tab bar colors
        tab_bar = {
            background = colors.bg,
            active_tab = {
                bg_color = colors.accent,
                fg_color = colors.fg,
            },
            inactive_tab = {
                bg_color = colors.alt_bg,
                fg_color = colors.medium_gray,
            },
            inactive_tab_hover = {
                bg_color = colors.gray,
                fg_color = colors.fg,
            },
            new_tab = {
                bg_color = colors.alt_bg,
                fg_color = colors.medium_gray,
            },
            new_tab_hover = {
                bg_color = colors.gray,
                fg_color = colors.fg,
            },
            inactive_tab_edge = colors.alt_bg,
        },

        -- Visual bell color
        visual_bell = colors.accent,
    }
end

-- Apply the theme to Wezterm config
function M.apply_to_config(config)
    config.colors = M.get_theme()

    -- Window frame colors
    config.window_frame = {
        active_titlebar_bg = colors.bg,
        active_titlebar_fg = colors.fg,
        inactive_titlebar_bg = colors.alt_bg,
        inactive_titlebar_fg = colors.medium_gray,
        button_fg = colors.fg,
        button_bg = colors.accent,
    }
end

return M
