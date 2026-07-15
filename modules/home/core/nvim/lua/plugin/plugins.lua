local add = vim.pack.add

vim.cmd.packadd('nvim.undotree')
add({
    'gh:nvim-treesitter/nvim-treesitter',
    { src = 'gh:nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
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
})
