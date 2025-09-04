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
