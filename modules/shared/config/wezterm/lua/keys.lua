local wezterm = require "wezterm"
local utils = require "lua/utils"
local workspaces = require "lua/launchers/workspaces"
local run = require "lua/launchers/run"
local nvimPanes = require "lua/neovim-splits"

local act = wezterm.action

local make_leader_action = utils.make_leader_action
local make_pane_resize = utils.make_pane_resize

local M = {}

local baseKeys = {

    -- Fuzzy search workspaces
    make_leader_action(
        "s",
        act.ShowLauncherArgs {
            flags = "FUZZY|WORKSPACES",
        }
    ),

    -- Custom todo pane action
    make_leader_action(
        "t",
        wezterm.action.SplitPane {
            direction = "Right",
            command = {
                args = {
                    "zsh",
                    "-i",
                    "-c",
                    "nvim todo/$(git branch --show-current)",
                },
            },
        }
    ),

    -- Pane management
    make_leader_action("d", act.CloseCurrentPane { confirm = true }),
    make_leader_action("h", act.SplitVertical { domain = "CurrentPaneDomain" }),
    make_leader_action("v", act.SplitHorizontal { domain = "CurrentPaneDomain" }),
    make_leader_action("c", act.SpawnTab "CurrentPaneDomain"),
    make_leader_action("m", act.TogglePaneZoomState),
    make_leader_action("Enter", wezterm.action.ActivateCopyMode),

    -- Pane resizing
    make_pane_resize "Left",
    make_pane_resize "Down",
    make_pane_resize "Up",
    make_pane_resize "Right",
}

M.keys = utils.extend_list(baseKeys, nvimPanes.keys, workspaces.keys, run.keys)

return M
