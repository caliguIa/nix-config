require('nvim-treesitter.configs').setup({
    incremental_selection = { enable = false },
    textobjects = { enable = false },
    indent = { enable = true },
    highlight = { enable = true },
})
require('ts-comments').setup()
require('nvim-ts-autotag').setup()
require('fold_imports').setup()
require('timber').setup()
