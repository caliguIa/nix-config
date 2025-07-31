require('mini.pick').setup()

local cmd = vim.cmd
vim.ui.select = MiniPick.ui_select

Util.map.nl('cs', function() cmd.Pick('spellsuggest') end, 'Spelling')
Util.map.nl('sm', function() cmd.Pick('visit_paths', 'filter="core"') end, 'Marked files')
Util.map.nl('sf', function() cmd.Pick('files') end, 'Find Files')
Util.map.nl('sg', function() cmd.Pick('grep_live') end, 'Grep')
Util.map.nl('sG', function() cmd.Pick('grep', "pattern='<cword>'") end, 'Grep current word')
Util.map.nl('sh', function() cmd.Pick('help') end, 'Help Pages')
Util.map.nl('sH', function() cmd.Pick('hl_groups') end, 'Highlight groups')
Util.map.nl('sk', function() cmd.Pick('keymaps') end, 'Keymaps')
Util.map.nl('sr', function() cmd.Pick('resume') end, 'Resume')
Util.map.nl('sb', function()
    MiniPick.builtin.buffers({ include_current = false }, {
        mappings = {
            wipeout = {
                char = '<C-d>',
                func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
            },
        },
    })
end, 'Buffers')
