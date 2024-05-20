local keymap = vim.keymap

keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
keymap.set('n', '<leader>wh', '<C-w>s', { desc = 'Split window horizontally' })
keymap.set('n', '<leader>we', '<C-w>=', { desc = 'Make splits equal size' })
keymap.set('n', '<leader>wx', '<cmd>close<CR>', { desc = 'Close current split' })

keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

keymap.set('n', '<C-d>', '<C-d>zz')
keymap.set('n', '<C-u>', '<C-u>zz')

keymap.set('n', 'Q', '<nop>')

keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })
