return {
    {
        "oliverhkraft/nvim-pint",
        config = function()
            require("nvim-pint").setup({
                silent = false,
                exclude_folders = { "resources/views" },
            })
        end,
    },
}
