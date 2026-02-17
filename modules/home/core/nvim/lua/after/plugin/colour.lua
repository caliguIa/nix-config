vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('highlight_group_overrides', { clear = false }),
    callback = function()
        vim.api.nvim_set_hl(0, 'MiniJump', { link = 'Search' })
        vim.api.nvim_set_hl(0, 'MatchParen', { link = 'Search' })
    end,
    desc = 'Override some highlight groups',
})
vim.cmd.colorscheme('kanso')
vim.schedule(vim.cmd.KansoCompile)
