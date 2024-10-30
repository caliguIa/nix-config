local wezterm = require "wezterm"
local utils = require "lua/utils"
local workspaces = require "lua/launchers/workspaces"
local run = require "lua/launchers/run"

local act = wezterm.action

local M = {}

M.keys = {
    workspaces.keymap,
    run.keymap,
    {
        mods = "LEADER",
        key = "s",
        action = act.ShowLauncherArgs {
            flags = "FUZZY|WORKSPACES",
        },
    },
    {
        key = "t",
        mods = "LEADER",
        action = wezterm.action.SplitPane {
            direction = "Right",
            command = {
                args = {
                    "zsh",
                    "-i",
                    "-c",
                    "nvim todo/$(git branch --show-current)",
                },
            },
        },
    },
    {
        key = "d",
        mods = "LEADER",
        action = act.CloseCurrentPane { confirm = true },
    },
    {
        mods = "LEADER",
        key = "h",
        action = act.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
        mods = "LEADER",
        key = "v",
        action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    {
        mods = "LEADER",
        key = "c",
        action = act.SpawnTab "CurrentPaneDomain",
    },
    {
        mods = "LEADER",
        key = "m",
        action = act.TogglePaneZoomState,
    },
    {
        key = "Enter",
        mods = "LEADER",
        action = wezterm.action.ActivateCopyMode,
    },
    {
        key = "h",
        mods = "CMD|CTRL|SHIFT|OPT",
        action = act.ActivatePaneDirection "Left",
    },
    {
        key = "l",
        mods = "CMD|CTRL|SHIFT|OPT",
        action = act.ActivatePaneDirection "Right",
    },
    {
        key = "k",
        mods = "CMD|CTRL|SHIFT|OPT",
        action = act.ActivatePaneDirection "Up",
    },
    {
        key = "j",
        mods = "CMD|CTRL|SHIFT|OPT",
        action = act.ActivatePaneDirection "Down",
    },
    {
        key = "H",
        mods = "LEADER",
        action = act.AdjustPaneSize { "Left", 15 },
    },
    {
        key = "J",
        mods = "LEADER",
        action = act.AdjustPaneSize { "Down", 15 },
    },
    {
        key = "K",
        mods = "LEADER",
        action = act.AdjustPaneSize { "Up", 15 },
    },
    {
        key = "L",
        mods = "LEADER",
        action = act.AdjustPaneSize { "Right", 15 },
    },
}

return M
