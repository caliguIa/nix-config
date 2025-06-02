local lsp = vim.lsp
local methods = lsp.protocol.Methods
local cmd = vim.cmd

lsp.enable({
    'cssls',
    'cssmodules_ls',
    'docker_compose_language_service',
    'dockerls',
    'eslint',
    'intelephense',
    'jsonls',
    'lua_ls',
    'marksman',
    'nixd',
    'rust_analyzer',
    'taplo',
    'vtsls',
    'zls',
})

local setup_keymaps = function(event)
    Util.map.n('K', lsp.buf.hover, 'Hover', { buffer = event.buf })
    Util.map.nl('e', vim.diagnostic.open_float, 'Diagnostics')
    Util.map.nl('rn', lsp.buf.rename, 'Rename')
    Util.map.nl('ca', lsp.buf.code_action, 'Code action')
    Util.map.nl('ss', function() cmd.Pick('lsp', 'scope="document_symbol"') end, 'Document LSP symbols')
    Util.map.nl('sS', function() cmd.Pick('lsp ', 'scope="workspace_symbol"') end, 'Workspace LSP symbols')
    Util.map.n('gd', function() cmd.Pick('lsp', 'scope="definition"') end, 'Definition')
    Util.map.n('gD', function() cmd.Pick('lsp', 'scope="declaration"') end, 'Declaration')
    Util.map.n('gr', function() cmd.Pick('lsp', 'scope="references"') end, 'References')
    Util.map.n('gt', function() cmd.Pick('lsp', 'scope="type_definition"') end, 'Type definition')
    Util.map.n('gi', function() cmd.Pick('lsp', 'scope="implementation"') end, 'Implementation')
end

local init_doc_hl = function(event)
    local highlight_augroup = Util.au.group('lsp-highlight', { clear = false })
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
        callback = function(event2)
            lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event2.buf })
        end,
    })
end

local init_lsp_folds = function()
    local win = vim.api.nvim_get_current_win()

    vim.wo[win][0].foldmethod = 'expr'
    vim.wo[win][0].foldexpr = 'v:lua.lsp.foldexpr()'
    Util.au.cmd('LspDetach', { group = Util.au.group('lsp-folds-unset'), command = 'setl foldexpr<' })
end

Util.au.cmd('LspAttach', {
    group = Util.au.group('lsp-attach'),
    callback = function(event)
        setup_keymaps(event)

        local client = lsp.get_client_by_id(event.data.client_id)
        if client then
            if client:supports_method(methods.textDocument_documentHighlight, event.buf) then init_doc_hl(event) end
            if client:supports_method(methods.textDocument_foldingRange, event.buf) then init_lsp_folds() end
        end

        vim.diagnostic.config({
            signs = false,
            virtual_text = false,
            underline = true,
        })
    end,
})
