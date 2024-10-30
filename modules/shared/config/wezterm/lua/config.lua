local utils = require "lua/utils"

local M = {}

M.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }

M.default_prog = { utils.homeDir .. "/.nix-profile/bin/zsh", "-l" }

M.set_environment_variables = {
    EDITOR = "nvim",
    PATH = "/opt/homebrew/bin:" .. utils.homeDir .. "/.nix-profile/bin:" .. os.getenv "PATH",
}

M.term = "wezterm"
M.animation_fps = 120
M.max_fps = 120
M.front_end = "WebGpu"
M.webgpu_power_preference = "HighPerformance"

return M