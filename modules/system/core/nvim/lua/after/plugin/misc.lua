local quicker = require('quicker')
quicker.setup()
vim.keymap.set('n', '<leader>q', function() quicker.toggle() end, { desc = 'Toggle quickfix' })
vim.keymap.set('n', '<leader>u', vim.cmd.Undotree, { desc = 'Undotree', silent = true })
