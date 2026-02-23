require('indentmini').setup()
require('bqf').setup({})

vim.keymap.set('n', '<leader>u', vim.cmd.Undotree, { desc = 'Undotree', silent = true })
