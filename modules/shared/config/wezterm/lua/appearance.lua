local wezterm = require "wezterm"

local M = {}

M.color_scheme = "Catppuccin Mocha"

M.font = wezterm.font "BerkeleyMono Nerd Font"
M.font_size = 14
M.line_height = 1.5

M.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
M.window_decorations = "RESIZE"

M.default_cursor_style = "BlinkingBar"
M.enable_tab_bar = true
M.use_fancy_tab_bar = false
M.hide_tab_bar_if_only_one_tab = true
M.initial_cols = 500
M.initial_rows = 500

return M
