local wezterm = require "wezterm"
local consts = require "lua/consts"

local path = consts.path

local M = {}

M.font = wezterm.font "BerkeleyMono Nerd Font"
M.font_size = 13
M.line_height = 1.6

M.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
M.window_decorations = "RESIZE"
-- M.window_background_image = path.HOME .. "/Pictures/bg.jpg"
-- M.window_background_image_hsb = {
--     brightness = 0.003,
--     hue = 1.0,
--     saturation = 0.8,
-- }

M.default_cursor_style = "BlinkingBar"
M.enable_tab_bar = true
M.use_fancy_tab_bar = false
M.hide_tab_bar_if_only_one_tab = true
M.initial_cols = 500
M.initial_rows = 500

return M
