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
    callback = function() vim.hl.hl_op({ higroup = 'Visual', timeout = 300 }) end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Close certain filetypes with <q>',
    group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
    -- stylua: ignore
    pattern = {
        "checkhealth", "dbout", "git", "help", "lspinfo", "qf", "fugitive",
        "notify", "startuptime", "tsplayground", "fugitiveblame", "sqls_output",
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

vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end
        local value = ev.data.params.value
        if not value.kind == 'end' then return end
        local msg = ('[%s] %s %s'):format(client.name, '✓', value.title or '')
        vim.notify(msg)
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'msg',
    callback = function()
        local ui2 = require('vim._core.ui2')
        local win = ui2.wins and ui2.wins.msg
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_option_value(
                'winhighlight',
                'Normal:NormalFloat,FloatBorder:FloatBorder',
                { scope = 'local', win = win }
            )
        end
    end,
})
