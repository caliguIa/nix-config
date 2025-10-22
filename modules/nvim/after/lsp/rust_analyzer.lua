---@type vim.lsp.Config
return {
    settings = {
        diagnostics = {
            enable = true,
            experimental = {
                enable = true,
            },
        },
        assist = {
            importEnforceGranularity = true,
            importPrefix = 'crate',
        },
        cargo = {
            allFeatures = true,
        },
        checkOnSave = {
            command = 'clippy',
        },
    },
}
