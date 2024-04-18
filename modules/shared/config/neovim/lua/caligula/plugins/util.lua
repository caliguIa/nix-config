return {
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = { options = vim.opt.sessionoptions:get() },
        -- stylua: ignore
        keys = {
          { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
          { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
          { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
        },
    },

    {
        "sontungexpt/url-open",
        event = "VeryLazy",
        cmd = "URLOpenUnderCursor",
        opts = {},
        keys = {
            { "gx", "<ESC>:URLOpenUnderCursor<CR>", mode = { "n" }, desc = "Open URL under cursor" },
        },
    },

    "tpope/vim-sleuth",

    "nvim-lua/plenary.nvim",

    { "echasnovski/mini.basics", version = "*" },
}
