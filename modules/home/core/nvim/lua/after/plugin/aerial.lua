local aerial = require('aerial')
aerial.setup({
    open_automatic = function(bufnr)
        return vim.api.nvim_buf_line_count(bufnr) > 80 and aerial.num_symbols(bufnr) > 4 and not aerial.was_closed()
    end,
    on_attach = function(bufnr)
        vim.keymap.set('n', '{', vim.cmd.AerialPrev, { buffer = bufnr })
        vim.keymap.set('n', '}', vim.cmd.AerialNext, { buffer = bufnr })
    end,
    ignore = {
        -- stylua: ignore
        filetypes = {
            "checkhealth", "dbout", "git", "help", "lspinfo", "qf", "fugitive",
            "notify", "startuptime", "tsplayground", "fugitiveblame", "oil"
        },
    },
})
vim.keymap.set('n', '<leader>a', function() vim.cmd.AerialToggle('right') end, { desc = 'Aerial' })
