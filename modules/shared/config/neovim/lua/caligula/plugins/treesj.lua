return {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        local treesj = require("treesj")
        treesj.setup({
            use_default_keymaps = false,
        })

        vim.keymap.set("n", "<leader>ct", treesj.toggle, { desc = "[C]ode chunk toggle split/join" })
        vim.keymap.set("n", "<leader>cs", treesj.split, { desc = "C]ode chunk [s]plit" })
        vim.keymap.set("n", "<leader>cj", treesj.join, { desc = "[C]ode chunk [j]oin" })
    end,
}
