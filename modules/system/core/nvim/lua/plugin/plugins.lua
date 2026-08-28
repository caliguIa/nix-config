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
    'gh:nvim-treesitter/nvim-treesitter',
    'gh:nvim-treesitter/nvim-treesitter-textobjects',
    'gh:Goose97/timber.nvim',
    'gh:folke/ts-comments.nvim',
    'gh:nvim-treesitter/nvim-treesitter-context',
    'gh:stevearc/conform.nvim',
    'gh:stevearc/quicker.nvim',
    'gh:stevearc/oil.nvim',
    'gh:webhooked/kanso.nvim',
    'gh:nvim-mini/mini.nvim',
    'gh:neovim/nvim-lspconfig',
    'cal:zendiagram.nvim',
    'gh:FabijanZulj/blame.nvim',
    'gh:barrettruth/diffs.nvim',
    'gh:NeogitOrg/neogit',
    'gh:sindrets/diffview.nvim',
    'gh:windwp/nvim-ts-autotag',
    'gh:stevearc/aerial.nvim',
    'gh:vim-test/vim-test',
    'gh:niekdomi/conflict.nvim',
    'gh:justinmk/guh.nvim',
    'gh:WTFox/luna.nvim',
})

vim.pack.add({
    'gh:MeanderingProgrammer/render-markdown.nvim',
}, {
    load = function() end,
})
