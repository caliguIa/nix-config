local wezterm = require "wezterm"
local utils = require "lua/utils"

local M = {}

local ousDir = utils.homeDir .. "/oneupsales"
local nixDir = utils.homeDir .. "/nix-config"

local choices = {
    { label = "oneupsales platform" },
    { label = "neovim config" },
    { label = "nix config" },
    { label = "wezterm config" },
    { label = "spotify" },
}

local choicesConfig = {
    ["oneupsales platform"] = { args = { "nvim" }, cwd = ousDir .. "/platform" },
    ["neovim config"] = { args = { "nvim" }, cwd = utils.homeDir },
    ["nix config"] = { args = { "nvim" }, cwd = nixDir },
    ["wezterm config"] = { args = { "nvim", "modules/shared/files/wezterm.lua" }, cwd = nixDir },
    spotify = { args = { "ncspot" }, cwd = utils.homeDir },
}

M.keymap = {
    mods = "LEADER",
    key = "f",
    action = wezterm.action.InputSelector {
        title = "Workspaces",
        choices = choices,
        fuzzy = true,
        action = wezterm.action_callback(function(window, pane, _, label)
            if not label then return end

            local config = choicesConfig[label]
            local workspace = { name = label, spawn = {} }

            if config.args then workspace.spawn.args = config.args end
            if config.cwd then workspace.spawn.cwd = config.cwd end

            window:perform_action(wezterm.action.SwitchToWorkspace(workspace), pane)
        end),
    },
}

return M
