---@type vim.lsp.Config
return {
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
            },
            imports = {
                granularity = {
                    enforce = true,
                },
                prefix = 'crate',
            },
            cargo = {
                features = 'all',
            },
            check = {
                command = 'clippy',
            },
        },
    },
}
