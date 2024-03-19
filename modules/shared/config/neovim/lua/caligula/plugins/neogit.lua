return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "sindrets/diffview.nvim", -- optional - Diff integration
        "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
        local neogit = require("neogit")
        neogit.setup()

        vim.keymap.set({ "n" }, "<leader>Go", function()
            neogit.open()
        end, { silent = true, desc = "Open neo[G]it" })

        vim.keymap.set({ "n" }, "<leader>Gs", function()
            neogit.open({ kind = "split" })
        end, { silent = true, desc = "Open neo[G]it split view" })

        vim.keymap.set({ "n" }, "<leader>Gc", function()
            neogit.open({ "commit" })
        end, { silent = true, desc = "[G]it commit" })
    end,
}
