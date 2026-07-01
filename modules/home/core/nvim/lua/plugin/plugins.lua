local add = vim.pack.add

vim.cmd.packadd('nvim.undotree')
add({
    'gh:nvim-treesitter/nvim-treesitter',
    { src = 'gh:nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
    'gh:Goose97/timber.nvim',
    'gh:folke/ts-comments.nvim',
    'gh:nvim-treesitter/nvim-treesitter-context',
    'gh:windwp/nvim-ts-autotag',
    'gh:stevearc/aerial.nvim',
    'gh:stevearc/conform.nvim',
    'gh:stevearc/quicker.nvim',
    'gh:stevearc/oil.nvim',
    'gh:webhooked/kanso.nvim',
    'gh:nvim-mini/mini.nvim',
    'gh:neovim/nvim-lspconfig',
    'gh:vim-test/vim-test',
    'cal:zendiagram.nvim',
    'gh:FabijanZulj/blame.nvim',
    'gh:niekdomi/conflict.nvim',
    'gh:justinmk/guh.nvim',
    'gh:barrettruth/diffs.nvim',
    'gh:NeogitOrg/neogit',
    'gh:sindrets/diffview.nvim',
})

-- On-demand plugins, not loaded until ":packadd …".
add({
    'gh:MeanderingProgrammer/render-markdown.nvim',
}, {
    load = function() end,
})

local dev_path = string.format('%s/dev/nvim-plugins/', vim.env.HOME)
local function add_local_plugin(name) vim.opt.runtimepath:prepend(string.format('%s%s', dev_path, name)) end
