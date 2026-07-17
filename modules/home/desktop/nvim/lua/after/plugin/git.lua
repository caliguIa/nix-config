require('conflict').setup({
    default_mappings = {
        current = 'co',
        incoming = 'ct',
    },
})

vim.api.nvim_create_user_command(
    'Gh',
    function() vim.cmd('tab Guh .') end,
    { desc = 'Restart neovim but maintain session' }
)

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'guh://*/prdiff/*',
    command = 'set filetype=diff',
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = 'guh://*/prcomments/*',
    callback = function(args)
        vim.bo[args.buf].filetype = 'diff'

        if vim.b[args.buf].prcomments_resized then return end

        local win = vim.fn.bufwinid(args.buf)
        if win ~= -1 then
            local total_width = vim.o.columns
            local height = vim.api.nvim_win_get_height(win)
            vim.api.nvim_win_resize(win, math.floor(total_width * 0.4), height, { anchor = 'right' })
            vim.b[args.buf].prcomments_resized = true
        end
    end,
})
