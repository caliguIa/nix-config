local jsFormatter = { "eslint", { "prettierd", "prettier" } }

return {
    {
        "stevearc/conform.nvim",
        lazy = true,
        event = { "BufWritePre", "BufNewFile" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = jsFormatter,
                typescript = jsFormatter,
                javascriptreact = jsFormatter,
                typescriptreact = jsFormatter,
                css = jsFormatter,
                scss = jsFormatter,
                sass = jsFormatter,
                json = jsFormatter,
                yaml = jsFormatter,
                markdown = jsFormatter,
                graphql = jsFormatter,
                nix = { "nixfmt" },
                -- php = { "pint" },
            },
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
            notify_on_error = true,
            formatters = {
                eslint_lsp = {
                    name = "eslint",
                    execute = function(config, _, callback)
                        local options = { name = config.name }

                        local lsp_format = require("conform.lsp_format")
                        lsp_format.format(options, callback)
                    end,
                },
            },
        },
        config = function(_, opts)
            local conform = require("conform")

            conform.setup(opts)

            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
                command = "silent! EslintFixAll",
                group = vim.api.nvim_create_augroup("MyAutocmdsJavaScripFormatting", {}),
            })

            vim.keymap.set({ "n", "v" }, "<leader>bf", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end, { desc = "[B]uffer [F]ormat" })
        end,
    },

    {
        "oliverhkraft/nvim-pint",
        opts = {
            silent = true,
            exclude_folders = { "resources/views" },
        },
    },
}
