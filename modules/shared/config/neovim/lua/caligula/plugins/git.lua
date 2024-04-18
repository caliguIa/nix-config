local icon = require("caligula.core.icons").misc.vertical_bar

return {
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy",
        opts = {},
        keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = icon },
                change = { text = icon },
                delete = { text = icon },
                topdelete = { text = icon },
                changedelete = { text = icon },
                untracked = { text = icon },
            },
            current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
            },
            signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            numhl = true, -- Toggle with `:Gitsigns toggle_nunhl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            sign_priority = 9,
            watch_gitdir = {
                interval = 1000,
            },
            attach_to_untracked = false,
            -- stylua: ignore
            on_attach = function(bufnr)
                vim.keymap.set( "n", "[c", require("gitsigns").prev_hunk, { buffer = bufnr, desc = "Go to Previous Hunk" })
                vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Go to Next Hunk" })
                vim.keymap.set( "n", "<leader>ph", require("gitsigns").preview_hunk, { buffer = bufnr, desc = "[P]review [H]unk" })
            end,
        },
    },

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim", -- optional - Diff integration
            "ibhagwan/fzf-lua",
            -- "nvim-telescope/telescope.nvim", -- optional
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
        -- stylua: ignore
        keys = {
            { "<leader>gg", function() require("neogit").open() end, desc = "Open neo[G]it", },
            { "<leader>gs", function() require("neogit").open({ kind = "split" }) end, desc = "Open neo[G]it [s]plit view", },
            { "<leader>gc", function() require("neogit").open({ "commit" }) end, desc = "[G]it [c]ommit", },
        },
    },

    {
        "pwntester/octo.nvim",
        cmd = "Octo",
        event = "BufReadPost",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "ibhagwan/fzf-lua",
            "nvim-tree/nvim-web-devicons",
        },
        opts = { picker = "fzf-lua", picker_config = { use_emojis = true } },
    },
}
