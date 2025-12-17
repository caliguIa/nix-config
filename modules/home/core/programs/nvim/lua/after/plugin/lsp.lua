local lsp = vim.lsp

lsp.enable({
    'cssls',
    'cssmodules_ls',
    -- 'css_variables',
    'docker_compose_language_service',
    'dockerls',
    'eslint',
    'intelephense',
    'jsonls',
    'just',
    'stylelint_lsp',
    'emmylua_ls',
    'laravel_ls',
    'marksman',
    'nixd',
    'rust_analyzer',
    'taplo',
    -- 'vtsls',
    'tsgo',
    'zls',
})

require('zendiagram').setup()
vim.diagnostic.open_float = Zendiagram.open

local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local safe_del = function(mode, lhs) pcall(vim.keymap.del, mode, lhs) end
        safe_del('n', 'grr')
        safe_del('n', 'gra')
        safe_del('n', 'gri')
        safe_del('n', 'grn')
        safe_del('n', 'grt')

        vim.keymap.set('n', 'gd', lsp.buf.definition, { desc = 'Definition', silent = true })
        vim.keymap.set('n', 'gr', lsp.buf.references, { desc = 'References', silent = true })
        vim.keymap.set('n', 'gt', lsp.buf.type_definition, { desc = 'Type definition', silent = true })
        vim.keymap.set('n', 'gD', lsp.buf.declaration, { desc = 'Declarations', silent = true })
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Diagnostics', silent = true })
        vim.keymap.set('n', '<leader>rn', lsp.buf.rename, { desc = 'Rename', silent = true })
        vim.keymap.set('n', '<leader>ca', lsp.buf.code_action, { desc = 'Code actions', silent = true })

        local client = lsp.get_client_by_id(event.data.client_id)
        if client then
            lsp.completion.enable(true, client.id, event.buf, {
                autotrigger = true,
                convert = function(item) return { abbr = item.label:gsub('%b()', '') } end,
            })

            if client:supports_method(lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = lsp.buf.clear_references,
                })
                vim.api.nvim_create_autocmd('LspDetach', {
                    group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                    callback = function(e)
                        lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = e.buf })
                    end,
                })
            end

            if client:supports_method(lsp.protocol.Methods.textDocument_foldingRange) then
                local win = vim.api.nvim_get_current_win()
                vim.wo[win][0].foldmethod = 'expr'
                vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
                vim.wo[win][0].foldtext = 'v:lua.vim.lsp.foldtext()'
            end
        end

        vim.diagnostic.config({
            signs = false,
            virtual_text = false,
            underline = true,
        })
    end,
})

vim.api.nvim_create_autocmd('LspNotify', {
    callback = function(args)
        if args.data.method == lsp.protocol.Methods.textDocument_didOpen then
            vim.schedule(function() lsp.foldclose('imports') end)
        end
    end,
})
