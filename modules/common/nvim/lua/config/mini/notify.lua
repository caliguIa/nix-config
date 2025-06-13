local not_lua_diagnosing = function(notif) return not vim.startswith(notif.msg, 'lua_ls: Diagnosing') end
local filterout_lua_diagnosing = function(notif_arr)
    return MiniNotify.default_sort(vim.tbl_filter(not_lua_diagnosing, notif_arr))
end
require('mini.notify').setup({
    content = { sort = filterout_lua_diagnosing },
    window = { config = { border = 'none' } },
})
vim.notify = MiniNotify.make_notify()
Util.map.nl('N', MiniNotify.show_history, 'Show notification history')
