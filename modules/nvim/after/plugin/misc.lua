require('indentmini').setup()
require('bqf').setup({})
require('codecompanion').setup({ strategies = { chat = { adapter = 'anthropic' } } })
require('ts-error-translator').setup()

local cmd = vim.cmd
vim.keymap.set('n', '<leader>cc', cmd.CodeCompanionChat, { desc = 'AI chat', silent = true })
vim.keymap.set('n', '<leader>u', cmd.Undotree, { desc = 'Undotree', silent = true })
vim.keymap.set('n', '<M-h>', cmd.TmuxNavigateLeft, { desc = 'Tmux Navigate Left', silent = true })
vim.keymap.set('n', '<M-j>', cmd.TmuxNavigateDown, { desc = 'Tmux Navigate Down', silent = true })
vim.keymap.set('n', '<M-k>', cmd.TmuxNavigateUp, { desc = 'Tmux Navigate Up', silent = true })
vim.keymap.set('n', '<M-l>', cmd.TmuxNavigateRight, { desc = 'Tmux Navigate Right', silent = true })
