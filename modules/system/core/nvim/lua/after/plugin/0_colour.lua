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
require('luna').setup({
    transparent = false,
    accent = 1.0, -- 0-1, blends syntax accents toward grey_light; 1 = full color
    plugins = {
        all = true, -- enable every plugin integration unconditionally
        auto = true, -- when plugins.all is false, autodetect via lazy.nvim
    },
    -- on_colors = function(colors) end,
    -- on_highlights = function(highlights, colors) end,
})

vim.o.background = 'dark'
vim.cmd.colorscheme('luna')
