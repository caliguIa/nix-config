require('codediff').setup()

vim.g.diffs = {
    fugitive = true,
    neogit = false,
    extra_filetypes = { 'diff' },
}

vim.keymap.set('n', '<leader>g', vim.cmd.CodeDiff, { desc = 'Status', silent = true })

vim.api.nvim_create_user_command('Diff', function() vim.cmd.G('blame') end, { desc = 'Git blame' })
vim.api.nvim_create_user_command('Blame', function() vim.cmd.CodeDiff('history') end, { desc = 'History (branch)' })
vim.api.nvim_create_user_command(
    'Blame',
    function() vim.cmd.CodeDiff('history HEAD~20 %') end,
    { desc = 'History (current file)' }
)
vim.api.nvim_create_user_command(
    'Blame',
    function() vim.cmd.CodeDiff('file HEAD~1') end,
    { desc = 'Diff current file' }
)
