require('git-conflict').setup({
    default_mappings = true,
    default_commands = true,
    disable_diagnostics = false,
    list_opener = 'copen',
    highlights = {
        incoming = 'DiffAdd',
        current = 'DiffText',
    },
    debug = false,
})
require('neogit').setup({
    initial_branch_name = 'OUS-',
})
vim.keymap.set('n', '<leader>gg', vim.cmd.Neogit, { desc = 'Git', silent = true })
