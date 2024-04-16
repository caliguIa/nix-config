return {
    "folke/trouble.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local trouble = require("trouble")
        trouble.setup()

        vim.keymap.set("n", "<leader>xx", function()
            trouble.toggle()
        end, { silent = true, desc = "Trouble toggle" })

        vim.keymap.set("n", "<leader>xw", function()
            trouble.toggle("workspace_diagnostics")
        end, { silent = true, desc = "[W]orkspace diagnostics" })

        vim.keymap.set("n", "<leader>xd", function()
            trouble.toggle("document_diagnostics")
        end, { silent = true, desc = "[D]ocument diagnostics" })

        vim.keymap.set("n", "<leader>xq", function()
            trouble.toggle("quickfix")
        end, { silent = true, desc = "[Q]uickfix" })

        vim.keymap.set("n", "<leader>xl", function()
            trouble.toggle("loclist")
        end, { silent = true, desc = "[L]ocation list" })

        vim.keymap.set("n", "gR", function()
            trouble.toggle("lsp_references")
        end, { silent = true, desc = "LSP [r]eferences" })
    end,
}
