return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {},
    config = function()
        require("ibl").setup({
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
            },
        })
    end,
}
