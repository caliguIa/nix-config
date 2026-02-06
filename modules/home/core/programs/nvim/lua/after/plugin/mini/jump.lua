local jump = require('mini.jump')
local jump2d = require('mini.jump2d')

jump.setup()
jump2d.setup({
    spotter = jump2d.builtin_opts.word_start.spotter,
    allowed_lines = {
        blank = false,
        fold = false,
    },
})

vim.keymap.set('n', '<esc>', function()
    vim.cmd.noh()
    jump.stop_jumping()
end, { desc = 'Escape and clear hlsearch', silent = true })
