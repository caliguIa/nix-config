return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                transparent_background = true,
                integrations = {
                    harpoon = true,
                    mason = true,
                    cmp = true,
                    gitsigns = true,
                    treesitter = true,
                    mini = true,
                },
                color_overrides = {
                    mocha = {
                        base = "#16181a",
                    },
                },
            })
        end,
    },
}
