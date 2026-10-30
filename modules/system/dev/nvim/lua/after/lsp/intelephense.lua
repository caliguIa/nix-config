---@type vim.lsp.Config
return {
    init_options = {
        globalStoragePath = os.getenv('HOME') .. '/.cache/intelephense',
        licenceKey = os.getenv('INTELEPHENSE_KEY_PATH'),
        ['language_server_configuration.auto_config'] = true,
        ['code_transform.import_globals'] = true,
    },
    settings = {
        intelephense = {
            diagnostics = { enable = true },
            filetypes = { 'php', 'blade', 'php_only' },
            format = { enable = false },
            files = {
                associations = { '*.php', '*.blade.php' },
                maxSize = 5000000,
            },
            inlayHint = {
                parameterNames = false,
                parameterTypes = false,
                returnTypes = false,
            },
            references = {
                exclude = {
                    '**/vendor/**',
                    '**/_ide_helper*.php',
                },
            },
        },
        php = { completion = { callSnippet = 'Replace' } },
    },
}
