local lsp = vim.lsp

lsp.enable({
    'cssls',
    'cssmodules_ls',
    'docker_compose_language_service',
    'dockerls',
    'eslint',
    'intelephense',
    'jsonls',
    'just',
    -- 'lua_ls',
    'emmylua_ls',
    'laravel_ls',
    'marksman',
    'nixd',
    'rust_analyzer',
    'taplo',
    'vtsls',
    'zls',
})

local highlight_augroup = Util.au.group('lsp-highlight', { clear = false })
Util.au.cmd('LspAttach', {
    group = Util.au.group('lsp-attach'),
    callback = function(event)
        local safe_del = function(mode, lhs) pcall(vim.keymap.del, mode, lhs) end
        safe_del('n', 'grr')
        safe_del('n', 'gra')
        safe_del('n', 'gri')
        safe_del('n', 'grn')
        safe_del('n', 'grt')

        Util.map.n('gd', vim.lsp.buf.definition, 'Definition')
        Util.map.n('gr', vim.lsp.buf.references, 'References')
        Util.map.n('gt', vim.lsp.buf.type_definition, 'Type definition')
        Util.map.n('gD', vim.lsp.buf.declaration, 'Declarations')
        Util.map.nl('e', vim.diagnostic.open_float, 'Diagnostics')
        Util.map.nl('rn', vim.lsp.buf.rename, 'Rename')
        Util.map.nl('ca', vim.lsp.buf.code_action, 'Code actions')

        local client = lsp.get_client_by_id(event.data.client_id)
        if client then
            vim.lsp.completion.enable(true, client.id, event.buf, {
                autotrigger = true,
                convert = function(item) return { abbr = item.label:gsub('%b()', '') } end,
            })

            if client:supports_method(lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                Util.au.cmd({ 'CursorHold', 'CursorHoldI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = lsp.buf.document_highlight,
                })
                Util.au.cmd({ 'CursorMoved', 'CursorMovedI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = lsp.buf.clear_references,
                })
                Util.au.cmd('LspDetach', {
                    group = Util.au.group('lsp-detach', { clear = true }),
                    callback = function(e)
                        lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = e.buf })
                    end,
                })
            end

            if client:supports_method(lsp.protocol.Methods.textDocument_foldingRange, event.buf) then
                local win = vim.api.nvim_get_current_win()
                vim.wo[win][0].foldmethod = 'expr'
                vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
            end
        end

        vim.diagnostic.config({
            signs = false,
            virtual_text = false,
            underline = true,
        })
    end,
})
