local fff = require('fff')
fff.setup()
vim.keymap.set('n', '<leader>sf', fff.find_files, { desc = 'Search files', silent = true })
