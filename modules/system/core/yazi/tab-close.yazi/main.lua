--- @since 26.9.1
-- Close the current tab; never quits (tab_close no-ops on the last tab).
-- Built-in tab_close defaults to the first tab, and `close` quits on the last.
local current = ya.sync(function() return cx.tabs.idx - 1 end)

return {
	entry = function() ya.emit('tab_close', { current() }) end,
}
