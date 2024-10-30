local wezterm = require "wezterm"
local utils = require "lua/utils"

local M = {}

local ousDir = utils.homeDir .. "/oneupsales"
local nixDir = utils.homeDir .. "/nix-config"

local pause = "; read -s -k '?Press any key to continue...'"

local choices = {
    { label = "git merge origin/main" },
    { label = "oneupsales bounce" },
    { label = "nix build switch" },
}

--stylua: ignore
local choicesConfig = {
    ["git merge origin/main"] = { args = { "zsh", "-i", "-c", "git fetch && git pull && git merge origin/main" .. pause } },
    ["oneupsales bounce"] = { args = { "zsh", "-i", "-c", "make down && make platform-up" .. pause }, cwd = ousDir },
    ["nix build switch"] = { args = { "zsh", "-i", "-c", "just build" .. pause }, cwd = nixDir },
}

M.keymap = {
    mods = "LEADER",
    key = "r",
    action = wezterm.action.InputSelector {
        title = "Commands",
        choices = choices,
        fuzzy = true,
        action = wezterm.action_callback(function(window, pane, _, label)
            if not label then return end

            local config = choicesConfig[label]
            local split = {
                direction = "Right",
                size = { Percent = 30 },
                command = {},
            }

            if config.args then split.command.args = config.args end
            if config.cwd then split.command.cwd = config.cwd end

            window:perform_action(wezterm.action.SplitPane(split), pane)
        end),
    },
}

return M
