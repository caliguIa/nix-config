return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local keymap = vim.keymap

        keymap.set("n", "<leader>h", "<CMD>lua require('harpoon.ui').toggle_quick_menu()<CR>", {
            silent = true,
            desc = "[H]arpoon menu",
        })
        keymap.set("n", "ma", "<CMD>lua require('harpoon.mark').add_file()<CR>", {
            silent = true,
            desc = "[M]ark [A]dd file",
        })
        keymap.set("n", "mj", "<CMD>lua require('harpoon.ui').nav_file(1)<CR>", {
            silent = true,
            desc = "Harpoon jump to [M]ark [J] (1)",
        })
        keymap.set("n", "mk", "<CMD>lua require('harpoon.ui').nav_file(2)<CR>", {
            silent = true,
            desc = "Harpoon jump to [M]ark [K] (2)",
        })
        keymap.set("n", "ml", "<CMD>lua require('harpoon.ui').nav_file(3)<CR>", {
            silent = true,
            desc = "Harpoon jump to [M]ark [L] (3)",
        })
        keymap.set("n", "m;", "<CMD>lua require('harpoon.ui').nav_file(4)<CR>", {
            silent = true,
            desc = "Harpoon jump to [M]ark [;] (4)",
        })
    end,
}
