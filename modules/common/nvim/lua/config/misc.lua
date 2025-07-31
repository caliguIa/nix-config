require('indentmini').setup()
require('bqf').setup({})
require('codecompanion').setup({ strategies = { chat = { adapter = 'anthropic' } } })

local cmd = vim.cmd
Util.map.nl('cc', cmd.CodeCompanionChat, 'AI chat')
Util.map.nl('u', cmd.UndotreeToggle, 'Toggle undotree')
Util.map.n('<M-h>', cmd.TmuxNavigateLeft, 'Tmux Navigate Left')
Util.map.n('<M-j>', cmd.TmuxNavigateDown, 'Tmux Navigate Down')
Util.map.n('<M-k>', cmd.TmuxNavigateUp, 'Tmux Navigate Up')
Util.map.n('<M-l>', cmd.TmuxNavigateRight, 'Tmux Navigate Right')
