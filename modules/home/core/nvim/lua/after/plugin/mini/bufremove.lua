local bufremove = require('mini.bufremove')
bufremove.setup()

local delete_other_buffers = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local all_bufs = vim.api.nvim_list_bufs()

    for _, buf in ipairs(all_bufs) do
        -- Skip the current buffer and non-listed/invalid buffers
        if buf ~= current_buf and vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_is_valid(buf) then
            bufremove.delete(buf, true) -- Using force=true to skip confirmation
        end
    end
end

vim.api.nvim_create_user_command('BufDeleteOthers', delete_other_buffers, { desc = 'Delete other buffers' })

vim.keymap.set('n', '<leader>bo', delete_other_buffers, { desc = 'Delete other buffers', silent = true })
vim.keymap.set(
    'n',
    '<leader>bd',
    function() bufremove.delete(vim.api.nvim_get_current_buf()) end,
    { desc = 'Delete current buffer', silent = true }
)
