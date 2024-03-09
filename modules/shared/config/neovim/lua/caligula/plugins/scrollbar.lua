return {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("scrollbar").setup()
    end,
}
