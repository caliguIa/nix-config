---@diagnostic disable-next-line: missing-fields, param-type-mismatch
require('kanso').setup({
    overrides = function(_colors)
        return {
            MiniJump = { link = 'MiniJump2dSpot' },
            MatchParen = { link = 'MiniJump2dSpot' },
        }
    end,
    background = {
        dark = 'zen', -- "zen", "mist" or "pearl"
        light = 'pearl', -- "zen", "mist" or "ink"
    },
    minimal = true,
})

vim.o.background = 'light'
vim.cmd.colorscheme('kanso')
