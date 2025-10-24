require('mini.completion').setup({
    lsp_completion = { source_func = 'omnifunc', auto_setup = false },
})

vim.lsp.config('*', {
    capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        MiniCompletion.get_lsp_capabilities()
    ),
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach-mini-comp', { clear = true }),
    callback = function(args) vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
})

vim.api.nvim_create_autocmd('WinEnter', {
    group = vim.api.nvim_create_augroup('mini-comp-fff', { clear = true }),
    callback = function()
        if vim.bo.filetype == 'fff_input' then vim.b.minicompletion_disable = true end
    end,
})
