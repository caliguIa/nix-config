vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    desc = 'Reload file if changed',
    group = vim.api.nvim_create_augroup('checktime', { clear = true }),
    callback = function()
        if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight on yank',
    group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Close certain filetypes with <q>',
    group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
    -- stylua: ignore
    pattern = {
        "checkhealth", "dbout", "git", "help", "lspinfo", "qf", "fugitive",
        "notify", "startuptime", "tsplayground", "fugitiveblame"
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set(
                'n',
                'q',
                function() pcall(vim.api.nvim_buf_delete, event.buf, { force = true }) end,
                { desc = 'Close buffer', silent = true, buffer = event.buf }
            )
        end)
    end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    desc = 'Open help buffers in a vsplit',
    group = vim.api.nvim_create_augroup('help_window_right', { clear = true }),
    pattern = { '*.txt' },
    callback = function()
        if vim.o.filetype == 'help' then vim.cmd.wincmd('L') end
    end,
})
