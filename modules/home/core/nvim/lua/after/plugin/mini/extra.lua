local misc = require('mini.misc')
require('mini.surround').setup()
require('mini.notify').setup()

misc.setup()
misc.setup_restore_cursor()

vim.api.nvim_create_user_command('Maximise', function() misc.zoom() end, { desc = 'Maximise window' })

vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'Find root and change current directory',
    group = vim.api.nvim_create_augroup('MiniMiscAutoRoot', { clear = true }),
    nested = true,
    callback = vim.schedule_wrap(function(data)
        if data.buf ~= vim.api.nvim_get_current_buf() then return end
        if vim.bo[data.buf].filetype == 'NeogitStatus' then return end

        vim.o.autochdir = false
        local root = misc.find_root(data.buf, { '.git', 'Makefile' })
        if root == nil then return end
        vim.fn.chdir(root)
    end),
})
