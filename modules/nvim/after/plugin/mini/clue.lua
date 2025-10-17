local miniclue = require('mini.clue')

miniclue.setup({
    clues = {
        {
            { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
            { mode = 'n', keys = '<Leader>c', desc = '+Code' },
            { mode = 'n', keys = '<Leader>d', desc = '+DB' },
            { mode = 'n', keys = '<Leader>f', desc = '+File' },
            { mode = 'n', keys = '<Leader>g', desc = '+Git' },
            { mode = 'n', keys = '<Leader>l', desc = '+Laravel' },
            { mode = 'n', keys = 'm', desc = '+Marks' },
            { mode = 'n', keys = '<Leader>r', desc = '+Rename' },
            { mode = 'n', keys = '<Leader>s', desc = '+Search' },
            { mode = 'n', keys = '<Leader>t', desc = '+Test' },
            { mode = 'n', keys = '<Leader>w', desc = '+Window' },
            { mode = 'n', keys = '<Leader><tab>', desc = '+Tabs' },
        },
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.windows({ submode_resize = true }),
        miniclue.gen_clues.z(),
    },
    triggers = {
        { mode = 'n', keys = '<Leader>' }, -- Leader triggers
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = [[\]] }, -- mini.basics
        { mode = 'n', keys = '[' }, -- mini.bracketed
        { mode = 'n', keys = ']' },
        { mode = 'n', keys = 'g' }, -- `g` key
        { mode = 'n', keys = 's' }, -- mini.surround
        { mode = 'v', keys = 's' }, -- mini.surround
        { mode = 'n', keys = 'w' }, -- mini.windows
        { mode = 'n', keys = '<C-w>' }, -- Window commands
        { mode = 'n', keys = 'z' }, -- `z` key
    },
})
