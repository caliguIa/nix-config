local add = vim.pack.add

vim.cmd.packadd('nvim.undotree')
add({
    'gh:nvim-treesitter/nvim-treesitter',
    { src = 'gh:nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
    'gh:stevearc/aerial.nvim',
    'gh:stevearc/conform.nvim',
    'gh:esmuellert/codediff.nvim',
    'gh:webhooked/kanso.nvim',
    'gh:nvim-mini/mini.nvim',
    'gh:kevinhwang91/nvim-bqf',
    'gh:neovim/nvim-lspconfig',
    'gh:windwp/nvim-ts-autotag',
    'gh:stevearc/oil.nvim',
    'gh:Goose97/timber.nvim',
    'gh:folke/ts-comments.nvim',
    'gh:vim-test/vim-test',
    'gh:caliguIa/zendiagram.nvim',
})

-- local dev_path = string.format('%s/dev/nvim-plugins/', vim.env.HOME)
-- local function add_local_plugin(name) vim.opt.runtimepath:prepend(string.format('%s%s', dev_path, name)) end
