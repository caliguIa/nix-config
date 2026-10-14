vim.api.nvim_create_user_command('Update', function()
    local inactive = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()
    vim.pack.del(inactive)
    vim.pack.update()
end, { desc = 'Update plugins' })

vim.cmd.packadd('nvim.undotree')
vim.pack.add({
    'gh:webhooked/kanso.nvim',
    'gh:nvim-mini/mini.nvim',
    'gh:neovim/nvim-lspconfig',
    'gh:nvim-treesitter/nvim-treesitter',
    'gh:nvim-treesitter/nvim-treesitter-context',
    'gh:nvim-treesitter/nvim-treesitter-textobjects',
    'gh:folke/ts-comments.nvim',
    'gh:windwp/nvim-ts-autotag',
    'gh:Goose97/timber.nvim',
    'gh:stevearc/aerial.nvim',
    'gh:stevearc/conform.nvim',
    'gh:stevearc/quicker.nvim',
    'gh:stevearc/oil.nvim',
    'cal:zendiagram.nvim',
    'gh:vim-test/vim-test',
    'gh:sindrets/diffview.nvim',
    'gh:barrettruth/diffs.nvim',
    'gh:NeogitOrg/neogit',
    'gh:FabijanZulj/blame.nvim',
    'gh:niekdomi/conflict.nvim',
    'gh:justinmk/guh.nvim',
})

vim.pack.add({
    'gh:MeanderingProgrammer/render-markdown.nvim',
}, {
    load = function() end,
})
