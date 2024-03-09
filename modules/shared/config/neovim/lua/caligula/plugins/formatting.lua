return {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufWritePre", "BufNewFile" },
    cmd = { "ConformInfo" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "eslint_d", { "prettier", "prettierd" } },
                typescript = { "eslint_d", { "prettier", "prettierd" } },
                javascriptreact = { "eslint_d", { "prettier", "prettierd" } },
                typescriptreact = { "eslint_d", { "prettier", "prettierd" } },
                css = { "eslint_d", { "prettier", "prettierd" } },
                scss = { "eslint_d", { "prettier", "prettierd" } },
                sass = { "eslint_d", { "prettier", "prettierd" } },
                json = { "eslint_d", { "prettier", "prettierd" } },
                yaml = { "eslint_d", { "prettier", "prettierd" } },
                markdown = { "eslint_d", { "prettier", "prettierd" } },
                graphql = { "eslint_d", { "prettier", "prettierd" } },
                nix = { "nixpkgs-fmt" },
            },
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
            notify_on_error = true,
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
