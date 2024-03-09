return {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("todo-comments").setup({})
    end,
}
