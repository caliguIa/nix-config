local wezterm = require "wezterm"
local act = wezterm.action

local M = {}

function M.merge_tables(...)
    local result = {}
    local tables = { ... }
    for i = 1, select("#", ...) do
        for k, v in pairs(tables[i]) do
            result[k] = v
        end
    end
    return result
end

function M.create_choices_from_config(configs)
    local choices = {}
    for label, _ in pairs(configs) do
        table.insert(choices, { label = label })
    end
    return choices
end

function M.make_leader_action(key, action)
    return {
        mods = "LEADER",
        key = key,
        action = action,
    }
end

function M.make_hyper_key_action(key, action)
    return {
        key = key,
        mods = "CMD|CTRL|SHIFT|OPT",
        action = action,
    }
end

function M.make_pane_resize(direction)
    return M.make_leader_action(direction:sub(1, 1):upper(), act.AdjustPaneSize { direction, 15 })
end

function M.make_pane_nav(direction, key) return M.make_hyper_key_action(key, act.ActivatePaneDirection(direction)) end

return M
