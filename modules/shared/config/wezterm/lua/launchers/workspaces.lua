local wezterm = require "wezterm"
local utils = require "lua/utils"
local consts = require "lua/consts"

local path = consts.path
local nix_shared_config = "/modules/shared/config"

local M = {}

local selectorConfigs = {
    ["oneupsales platform"] = { cwd = path.OUS .. "/platform" },
    ["neovim config"] = { cwd = path.NIX .. nix_shared_config .. "/nvim" },
    ["nix config"] = { cwd = path.NIX },
    ["wezterm config"] = {
        cwd = path.NIX .. nix_shared_config .. "/wezterm",
    },
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
