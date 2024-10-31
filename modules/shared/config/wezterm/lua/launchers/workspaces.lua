local wezterm = require "wezterm"
local utils = require "lua/utils"
local consts = require "lua/consts"

local path = consts.path

local M = {}

local selectorConfigs = {
    ["oneupsales platform"] = { args = { "nvim" }, cwd = path.OUS .. "/platform" },
    ["neovim config"] = { args = { "nvim" }, cwd = path.HOME .. "/.config/nvim" },
    ["nix config"] = { args = { "nvim" }, cwd = path.NIX },
    ["wezterm config"] = { args = { "nvim", "modules/shared/config/wezterm/wezterm.lua" }, cwd = path.NIX },
    spotify = { args = { "ncspot" }, cwd = path.HOME },
}

M.keys = {
    {
        mods = "LEADER",
        key = "f",
        action = wezterm.action.InputSelector {
            title = "Workspaces",
            choices = utils.create_choices_from_config(selectorConfigs),
            fuzzy = true,
            action = wezterm.action_callback(function(window, pane, _, label)
                if not label then return end

                local config = selectorConfigs[label]
                local workspace = { name = label, spawn = {} }

                if config.args then workspace.spawn.args = config.args end
                if config.cwd then workspace.spawn.cwd = config.cwd end

                window:perform_action(wezterm.action.SwitchToWorkspace(workspace), pane)
            end),
        },
    },
}

return M
