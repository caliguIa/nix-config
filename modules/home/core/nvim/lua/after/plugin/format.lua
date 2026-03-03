local conform = require('conform')

---@diagnostic disable-next-line: param-type-mismatch
conform.setup({
    formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'pint' },
        typescript = { 'biome' },
        typescriptreact = { 'biome' },
        javascript = { 'biome' },
        javascriptreact = { 'biome' },
        css = { 'biome' },
        html = { 'biome' },
        json = { 'biome' },
        jsonc = { 'biome' },
        markdown = { 'biome' },
        nix = { 'alejandra' },
        rust = { 'rustfmt' },
        scss = { 'biome' },
        sql = { 'sleek' },
        toml = { 'taplo' },
        mysql = { 'sleek' },
        vue = { 'biome' },
        yaml = { 'biome' },
        -- typescript = { 'prettier', 'biome', stop_after_first = true },
        -- typescriptreact = { 'prettier' },
        -- javascript = { 'prettier' },
        -- javascriptreact = { 'prettier' },
        -- css = { 'prettier' },
        -- html = { 'prettier' },
        -- json = { 'prettier' },
        -- jsonc = { 'prettier' },
        -- markdown = { 'prettier' },
        -- nix = { 'alejandra' },
        -- rust = { 'rustfmt' },
        -- scss = { 'prettier' },
        -- sql = { 'sleek' },
        -- toml = { 'taplo' },
        -- mysql = { 'sleek' },
        -- vue = { 'prettier' },
        -- yaml = { 'prettier' },
    },
})

vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('format-on-write', { clear = true }),
    callback = function()
        if vim.fn.exists(':LspEslintFixAll') > 0 then vim.cmd.LspEslintFixAll() end
        conform.format({ bufnr = vim.api.nvim_get_current_buf(), timeout_ms = 5000 })
    end,
})
