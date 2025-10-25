require('mini.diff').setup({
    view = {
        style = 'sign',
        signs = { add = '▎', change = '▎', delete = '' },
    },
})
vim.keymap.set('n', '<leader>go', function() MiniDiff.toggle_overlay(0) end, { desc = 'Diff overlay', silent = true })
