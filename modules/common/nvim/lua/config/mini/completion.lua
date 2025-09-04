require('mini.completion').setup({
    lsp_completion = { source_func = 'omnifunc', auto_setup = false },
})

Util.au.cmd('LspAttach', {
    group = Util.au.group('lsp-attach-mini-comp'),
    callback = function(args) vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
})

vim.lsp.config('*', {
    capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        MiniCompletion.get_lsp_capabilities()
    ),
})
