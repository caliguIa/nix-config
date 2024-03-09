return {
    "echasnovski/mini.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("mini.surround").setup()
        require("mini.operators").setup()
        require("mini.cursorword").setup()
        local hipatterns = require("mini.hipatterns")
        hipatterns.setup({
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })
        require("mini.basics").setup({
            options = {
                win_borders = "rounded",
            },
            autocommands = {
                relnum_in_visual_mode = true,
            },
            silent = true,
        })
    end,
}
