---@diagnostic disable-next-line: missing-fields, param-type-mismatch
require('kanso').setup({
    overrides = function(_colors)
        return {
            MiniJump = { link = 'MiniJump2dSpot' },
            MatchParen = { link = 'MiniJump2dSpot' },
        }
    end,
    background = {
        dark = 'mist', -- "zen", "ink", "mist"
        light = 'pearl', -- "pearl"
    },
    minimal = true,
})

vim.o.background = 'dark'
vim.cmd.colorscheme('kanso')
