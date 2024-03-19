return {
    "anuvyklack/windows.nvim",
    dependencies = { "anuvyklack/middleclass" },
    config = function()
        require("windows").setup({
            autowidth = {
                enable = false,
            },
            animation = {
                enable = false,
            },
        })
        vim.keymap.set(
            "n",
            "<leader>wm",
            "<CMD>WindowsMaximize<CR>",
            { noremap = true, silent = true, desc = "[W]indow [m]aximize" }
        )
    end,
}
