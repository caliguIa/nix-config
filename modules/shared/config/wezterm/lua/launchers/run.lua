local wezterm = require "wezterm"
local utils = require "lua/utils"
local consts = require "lua/consts"

local path = consts.path
local cmd = consts.cmd

local M = {}

--stylua: ignore
local selectorConfigs = {
    ["git merge origin/main"] = { args = { "zsh", "-i", "-c", "git fetch && git pull && git merge origin/main" .. cmd.CONFIRM } },
    ["oneupsales bounce"] = { args = { "zsh", "-i", "-c", "make down && make platform-up" .. cmd.CONFIRM }, cwd = path.OUS },
    ["nix build switch"] = { args = { "zsh", "-i", "-c", "just build" .. cmd.CONFIRM }, cwd = path.NIX },
    btm = { args = { "btm" }, },
    gitui = { args = { "gitui" } },
    lazydocker = { args = { "lazydocker" } },
    ['reload kanata config'] = { args = { "zsh", "-i", "-c", "sudo launchctl bootout system /Library/LaunchDaemons/com.caligula.kanata.plist && sudo launchctl bootstrap system /Library/LaunchDaemons/com.caligula.kanata.plist" .. cmd.CONFIRM } },
}

M.keys = {
    {
        mods = "LEADER",
        key = "r",
        action = wezterm.action.InputSelector {
            title = "Commands",
            choices = utils.create_choices_from_config(selectorConfigs),
            fuzzy = true,
            action = wezterm.action_callback(function(window, pane, _, label)
                if not label then return end

                local config = selectorConfigs[label]
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
    },
}

return M
