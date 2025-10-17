require('aerial').setup({
    open_automatic = true,
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
