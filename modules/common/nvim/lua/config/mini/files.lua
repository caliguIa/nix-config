require('mini.files').setup({
    mappings = {
        go_in = 'l',
        go_in_plus = '<CR>',
        go_out = 'h',
        go_out_plus = '-',
    },
})
Util.map.nl('fe', function()
    local path = vim.bo.buftype ~= 'nofile' and vim.api.nvim_buf_get_name(0) or nil
    MiniFiles.open(path)
end, 'File explorer')

Util.au.cmd('User', {
    group = Util.au.group('mini_files_rename'),
    pattern = 'MiniFilesActionRename',
    callback = function(event)
        local Methods = vim.lsp.protocol.Methods

        local changes = {
            files = {
                {
                    oldUri = vim.uri_from_fname(event.data.from),
                    newUri = vim.uri_from_fname(event.data.to),
                },
            },
        }
        local clients = vim.lsp.get_clients()
        for _, client in ipairs(clients) do
            if client:supports_method(Methods.workspace_willRenameFiles) then
                print(client.name)
                local resp = client:request_sync(Methods.workspace_willRenameFiles, changes, 1000, 0)
                if resp and resp.result ~= nil then
                    vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
                end
                if client:supports_method(Methods.workspace_didRenameFiles) then
                    client:notify(Methods.workspace_didRenameFiles, changes)
                end
            end
        end
    end,
})
