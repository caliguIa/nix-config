require('codediff').setup()

vim.keymap.set('n', '<leader>gg', vim.cmd.CodeDiff, { desc = 'Status', silent = true })
vim.keymap.set('n', '<leader>gb', function() vim.cmd.G('blame') end, { desc = 'Blame', silent = true })
vim.keymap.set(
    'n',
    '<leader>gh',
    function() vim.cmd.CodeDiff('history HEAD~20 %') end,
    { desc = 'History (current file)', silent = true }
)
vim.keymap.set(
    'n',
    '<leader>gH',
    function() vim.cmd.CodeDiff('history') end,
    { desc = 'History (branch)', silent = true }
)
vim.keymap.set(
    'n',
    '<leader>go',
    function() vim.cmd.CodeDiff('file HEAD') end,
    { desc = 'Diff current file', silent = true }
)
