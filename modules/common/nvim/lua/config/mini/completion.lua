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

Util.au.cmd('LspAttach', {
    group = Util.au.group('lsp-attach-mini-comp'),
    callback = function(args) vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
})

Util.au.cmd('WinEnter', {
    group = Util.au.group('mini-comp-fff'),
    callback = function()
        if vim.bo.filetype == 'fff_input' then vim.b.minicompletion_disable = true end
    end,
})
