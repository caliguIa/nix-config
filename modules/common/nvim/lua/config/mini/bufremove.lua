require('mini.bufremove').setup()
Util.map.nl('bd', function() MiniBufremove.delete(vim.api.nvim_get_current_buf()) end, 'Delete current')
Util.map.nl('bo', function()
    local current_buf = vim.api.nvim_get_current_buf()
    local all_bufs = vim.api.nvim_list_bufs()

    for _, buf in ipairs(all_bufs) do
        -- Skip the current buffer and non-listed/invalid buffers
        if buf ~= current_buf and vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_is_valid(buf) then
            MiniBufremove.delete(buf, true) -- Using force=true to skip confirmation
        end
    end
end, 'Delete others')
