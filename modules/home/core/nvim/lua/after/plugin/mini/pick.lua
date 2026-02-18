require('mini.pick').setup()

local cmd = vim.cmd
vim.ui.select = MiniPick.ui_select

local pick_files = function()
    require('mini.pick').builtin.cli({
        command = {
            'fd',
            '--type',
            'f',
            '--no-ignore',
            '--hidden',
            '--follow',
            '--exclude',
            '.git',
            '--exclude',
            'node_modules',
            '--exclude',
            'build',
            '--exclude',
            'tmp',
            '--exclude',
            'vendor',
            '--exclude',
            '.direnv',
        },
    }, {
        source = {
            name = 'All Files',
        },
    })
end

vim.keymap.set('n', '<leader>cs', function() cmd.Pick('spellsuggest') end, { desc = 'Spelling', silent = true })
vim.keymap.set(
    'n',
    '<leader>sm',
    function() cmd.Pick('visit_paths', 'filter="core"') end,
    { desc = 'Marked files', silent = true }
)
vim.keymap.set('n', '<leader>sf', pick_files, { desc = 'Search files', silent = true })
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
vim.keymap.set('n', '<leader>sb', function()
    MiniPick.builtin.buffers({ include_current = false }, {
        mappings = {
            wipeout = {
                char = '<C-d>',
                func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
            },
        },
    })
end, { desc = 'Buffers', silent = true })
