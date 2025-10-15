require('git-conflict').setup()
local neogit = require('neogit')
neogit.setup({
    initial_branch_name = 'OUS-',
})
vim.keymap.set('n', '<leader>gg', neogit.open, { desc = 'Git', silent = true })
