local ai = require('mini.ai')
local extra = require('mini.extra')

extra.setup()
ai.setup({
    n_lines = 500,
    custom_textobjects = {
        B = extra.gen_ai_spec.buffer(),
        f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        F = ai.gen_spec.function_call(),
    },
})
