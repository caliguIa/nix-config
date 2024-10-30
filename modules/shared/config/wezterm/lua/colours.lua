local M = {}

M.colors = {
    foreground = "#e1e1e1",
    background = "#151515",
    cursor_bg = "#D0D0D0",
    cursor_fg = "#212121",
    cursor_border = "#D0D0D0",
    selection_fg = "#e1e1e1",
    selection_bg = "#373737",
    scrollbar_thumb = "#373737",
    split = "#BAD7FF",
    ansi = {
        "#212121",
        "#b46958",
        "#90A959",
        "#586935",
        "#7E97AB",
        "#AA749F",
        "#88afa2",
        "#727272",
    },
    brights = {
        "#AFAFAF",
        "#984936",
        "#90A959",
        "#F4BF75",
        "#BAD7FF",
        "#AA759F",
        "#A2B5C1",
        "#373737",
    },
    -- compose_cursor = "#F4BF75",
    -- copy_mode_active_highlight_bg = { Color = "#373737" },
    -- copy_mode_active_highlight_fg = { Color = "#e1e1e1" },
    -- copy_mode_inactive_highlight_bg = { Color = "#373737" },
    -- copy_mode_inactive_highlight_fg = { Color = "#e1e1e1" },
    -- quick_select_label_bg = { Color = "#373737" },
    -- quick_select_label_fg = { Color = "#e1e1e1" },
    -- quick_select_match_bg = { Color = "#151515" },
    -- quick_select_match_fg = { Color = "#F4BF75" },
    tab_bar = {
        background = "#151515",
        active_tab = {
            bg_color = "#212121",
            fg_color = "#e1e1e1",
        },
        inactive_tab = {
            bg_color = "#151515",
            fg_color = "#e1e1e1",
        },
        inactive_tab_hover = {
            bg_color = "#373737",
            fg_color = "#e1e1e1",
        },
        new_tab = {
            bg_color = "#373737",
            fg_color = "#e1e1e1",
        },
        new_tab_hover = {
            bg_color = "#727272",
            fg_color = "#e1e1e1",
        },
        -- fancy tab bar
        inactive_tab_edge = "#151515",
    },
}

return M
