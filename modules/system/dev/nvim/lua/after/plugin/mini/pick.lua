local pick = require('mini.pick')

local choose_all = function()
    local mappings = pick.get_picker_opts().mappings
    vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
end

pick.setup({
    mappings = {
        choose_all = { char = '<C-q>', func = choose_all },
    },
})

local cmd = vim.cmd
vim.ui.select = pick.ui_select

vim.keymap.set('n', '<leader>cs', function() cmd.Pick('spellsuggest') end, { desc = 'Spelling', silent = true })
vim.keymap.set('n', '<leader>sf', function() cmd.Pick('files') end, { desc = 'Search files', silent = true })
vim.keymap.set('n', '<leader>sg', function() cmd.Pick('grep_live') end, { desc = 'Grep', silent = true })
vim.keymap.set(
    'n',
    '<leader>sG',
    function() cmd.Pick('grep', "pattern='<cword>'") end,
    { desc = 'Grep current word', silent = true }
)
vim.keymap.set('n', '<leader>sh', function() cmd.Pick('help') end, { desc = 'Help Pages', silent = true })
vim.keymap.set('n', '<leader>sH', function() cmd.Pick('hl_groups') end, { desc = 'Highlight groups', silent = true })
vim.keymap.set('n', '<leader>sk', function() cmd.Pick('keymaps') end, { desc = 'Keymaps', silent = true })
vim.keymap.set('n', '<leader>sr', function() cmd.Pick('resume') end, { desc = 'Resume', silent = true })
vim.keymap.set('n', '<leader>sc', function() cmd.Pick('commands') end, { desc = 'Resume', silent = true })
vim.keymap.set('n', '<leader>sb', function()
    pick.builtin.buffers({ include_current = false }, {
        mappings = {
            wipeout = {
                char = '<C-d>',
                func = function() vim.api.nvim_buf_delete(pick.get_picker_matches().current.bufnr, {}) end,
            },
        },
    })
end, { desc = 'Buffers', silent = true })
