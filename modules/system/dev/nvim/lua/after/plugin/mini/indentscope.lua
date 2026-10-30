local indentscope = require('mini.indentscope')
indentscope.setup({
    symbol = '│',
    options = {
        indent_at_cursor = false,
    },
    draw = {
        animation = indentscope.gen_animation.none(),
    },
})
