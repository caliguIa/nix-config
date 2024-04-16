return {
    "pmizio/typescript-tools.nvim",
    event = { "BufReadPre *.ts,*.tsx,*.js,*.jsx", "BufNewFile *.ts,*.tsx,*.js,*.jsx" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
        expose_as_code_action = "all",
        jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
        },
        settings = {
            tsserver_file_preferences = {
                includeInlayParameterNameHints = "all",
                includeInlayVariableTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
            },
        },
    },
}
