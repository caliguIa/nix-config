local conform = require('conform')

local js_formatter = { 'oxfmt' }
---@diagnostic disable-next-line: param-type-mismatch
conform.setup({
    formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'mago_format' },
        typescript = js_formatter,
        typescriptreact = js_formatter,
        javascript = js_formatter,
        javascriptreact = js_formatter,
        css = js_formatter,
        go = { 'gofmt' },
        html = js_formatter,
        json = js_formatter,
        jsonc = js_formatter,
        markdown = js_formatter,
        nix = { 'alejandra' },
        rust = { 'rustfmt' },
        scss = js_formatter,
        toml = { 'taplo' },
        sql = {
            'sql_formatter',
            -- 'sqruff',
            stop_after_first = true,
        },
        mysql = { 'sqruff' },
        vue = js_formatter,
        -- yaml = js_formatter,
        zig = { 'zigfmt' },
    },
})

vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('format-on-write', { clear = true }),
    callback = function(args) conform.format({ bufnr = args.buf, timeout_ms = 5000 }) end,
})
