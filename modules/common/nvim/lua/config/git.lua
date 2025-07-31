require('git-conflict').setup()

-- Util.map.nl('gg', vim.cmd.Git, 'Git')
Util.map.nl('gfa', function() vim.cmd.Git('fetch --all') end, 'Fetch all')
Util.map.nl('gfm', function()
    vim.cmd.Git('fetch --all')
    vim.cmd.Git('pull')
    vim.cmd.Git('merge origin/main')
end, 'Fetch all merge main')
Util.map.nl('gbb', function() vim.cmd.Git('blame') end, 'Git blame')
Util.map.nl('gbc', ':G checkout ', 'Git checkout branch')
Util.map.nl('gbl', function() vim.cmd.Git('branch -l') end, 'Git list branches')
Util.map.nl('gbn', ':G checkout -b ', 'Git create and checkout branch')
Util.map.nl('gp', function() vim.cmd.Git('pull') end, 'Pull')
Util.map.nl('gP', function() vim.cmd.Git('push') end, 'Push')

Util.au.cmd('FileType', {
    desc = 'Add custom fugitve summary keymaps',
    pattern = 'fugitive',
    callback = function()
        vim.cmd.resize()
        vim.api.nvim_buf_set_keymap(0, 'n', '<tab>', '=', { noremap = false, silent = true })
        vim.b.minisurround_disable = true
    end,
})

Util.au.cmd('BufEnter', {
    desc = 'Close fugitive window when opening a file from it',
    callback = function()
        if vim.bo.filetype == 'fugitive' then return end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local bufnr = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
            if ft == 'fugitive' then
                vim.api.nvim_win_close(win, false)
                break
            end
        end
    end,
})
