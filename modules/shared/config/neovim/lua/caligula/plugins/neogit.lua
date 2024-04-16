return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "sindrets/diffview.nvim", -- optional - Diff integration
        "ibhagwan/fzf-lua",
        -- "nvim-telescope/telescope.nvim", -- optional
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local neogit = require("neogit")
        neogit.setup()

        vim.keymap.set({ "n" }, "<leader>gg", function()
            neogit.open()
        end, { silent = true, desc = "Open neo[G]it" })

        vim.keymap.set({ "n" }, "<leader>gs", function()
            neogit.open({ kind = "split" })
        end, { silent = true, desc = "Open neo[G]it split view" })

        vim.keymap.set({ "n" }, "<leader>gc", function()
            neogit.open({ "commit" })
        end, { silent = true, desc = "[G]it commit" })
    end,
}
