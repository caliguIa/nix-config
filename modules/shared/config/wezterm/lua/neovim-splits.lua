local w = require "wezterm"

local M = {}

local function is_vim(pane) return pane:get_user_vars().IS_NVIM == "true" end

local direction_keys = {
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right",
}

local function split_nav(key)
    return {
        key = key,
        mods = "META",
        action = w.action_callback(function(win, pane)
            if is_vim(pane) then
                win:perform_action({
                    SendKey = { key = key, mods = "META" },
                }, pane)
            else
                win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
            end
        end),
    }
end

M.keys = {
    split_nav "h",
    split_nav "j",
    split_nav "k",
    split_nav "l",
}

return M
