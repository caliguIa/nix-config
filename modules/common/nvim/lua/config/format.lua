require('conform').setup({
    formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'pint' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        markdown = { 'prettier' },
        nix = { 'alejandra' },
        rust = { 'rustfmt' },
        scss = { 'prettier' },
        sql = { 'sleek' },
        toml = { 'taplo' },
        mysql = { 'sleek' },
        vue = { 'prettier' },
        yaml = { 'prettier' },
    },
})
local format_buffer = function()
    if vim.fn.exists(':LspEslintFixAll') > 0 then vim.cmd.LspEslintFixAll() end
    require('conform').format({ bufnr = vim.api.nvim_get_current_buf() })
end
Util.map.nl('bf', function() format_buffer() end, 'Format buffer')
Util.au.cmd('BufWritePre', {
    group = Util.au.group('format-on-write'),
    callback = function() format_buffer() end,
})
