require('codecompanion').setup({ strategies = { chat = { adapter = 'anthropic' } } })
Util.map.nl('cc', vim.cmd.CodeCompanionChat, 'AI chat')
