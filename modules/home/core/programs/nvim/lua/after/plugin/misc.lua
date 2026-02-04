require('indentmini').setup()
require('bqf').setup({})
-- require('codecompanion').setup({ ignore_warnings = true, strategies = { chat = { adapter = 'anthropic' } } })

local cmd = vim.cmd
vim.keymap.set('n', '<leader>cc', cmd.CodeCompanionChat, { desc = 'AI chat', silent = true })
vim.keymap.set('n', '<leader>u', cmd.Undotree, { desc = 'Undotree', silent = true })
