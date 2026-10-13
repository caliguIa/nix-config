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

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        vim.api.nvim_set_hl(0, 'SpellBad', { link = 'DiagnosticUnderlineHint' })
        vim.api.nvim_set_hl(0, 'SpellCap', { link = 'DiagnosticUnderlineHint' })
        vim.api.nvim_set_hl(0, 'SpellRare', { link = 'DiagnosticUnderlineHint' })
        vim.api.nvim_set_hl(0, 'SpellLocal', { link = 'DiagnosticUnderlineHint' })
    end,
})
