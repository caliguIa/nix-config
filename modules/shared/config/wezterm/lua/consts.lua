local wezterm = require "wezterm"

local M = {}

M.path = {
    HOME = wezterm.home_dir,
    NIX = wezterm.home_dir .. "/nix-config",
    OUS = wezterm.home_dir .. "/oneupsales",
}

M.cmd = {
    CONFIRM = "; read -s -k '?Press any key to continue...'",
}

return M
