-- 'end' progress events carry no title, so remember it from 'begin'.
local progress_titles = {}
vim.api.nvim_create_autocmd('LspProgress', {
    group = vim.api.nvim_create_augroup('lsp_progress_notify', { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end
        local token = ev.data.params.token
        local value = ev.data.params.value
        if value.kind == 'begin' then
            progress_titles[token] = value.title
            return
        end
        if value.kind ~= 'end' then return end
        local title = progress_titles[token] or value.message or ''
        progress_titles[token] = nil
        vim.notify(('[%s] %s %s'):format(client.name, '✓', title))
    end,
})

