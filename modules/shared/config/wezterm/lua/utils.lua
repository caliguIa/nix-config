local wezterm = require "wezterm"

local M = {}

function M.merge_tables(...)
    local result = {}
    for _, t in ipairs { ... } do
        for k, v in pairs(t) do
            result[k] = v
        end
    end
    return result
end

M.homeDir = wezterm.home_dir

return M
