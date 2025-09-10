require('nvim-treesitter.configs').setup({
    incremental_selection = { enable = false },
    textobjects = { enable = false },
    indent = { enable = true },
    highlight = { enable = true },
})
require('ts-comments').setup()
require('nvim-ts-autotag').setup({ enable_close_on_slash = false })
require('fold_imports').setup()

local js_like = {
    left = 'console.info("',
    right = '")',
    mid_var = '", ',
    right_var = ')',
}
require('debugprint').setup({
    print_tag = '',
    display_counter = false,
    display_location = false,
    keymaps = {
        normal = { variable_below = 'glj' },
        visual = { variable_below = 'glj' },
    },
    filetypes = {
        ['javascript'] = js_like,
        ['javascriptreact'] = js_like,
        ['typescript'] = js_like,
        ['typescriptreact'] = js_like,
        ['php'] = {
            left = "dump('",
            right = "')",
            mid_var = "', $",
            right_var = ');',
        },
    },
})
