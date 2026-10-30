local misc = require('mini.misc')
require('mini.surround').setup()

misc.setup()
misc.setup_restore_cursor()

-- Replicate `misc.setup_auto_root()` but skip Neogit status buffers.
vim.o.autochdir = false
local auto_root = vim.schedule_wrap(function(data)
    if data.buf ~= vim.api.nvim_get_current_buf() then return end
    if vim.bo[data.buf].filetype == 'NeogitStatus' then return end
    local root = misc.find_root(data.buf)
    if root == nil then return end
    vim.fn.chdir(root)
end)
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('MiniMiscAutoRoot', {}),
    nested = true,
    callback = auto_root,
    desc = 'Find root and change current directory',
})

vim.api.nvim_create_user_command('Maximise', function() misc.zoom() end, { desc = 'Maximise window' })
