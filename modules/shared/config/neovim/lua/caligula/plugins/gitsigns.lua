return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "│" },
            change = { text = "│" },
            delete = { text = "│" },
            topdelete = { text = "│" },
            changedelete = { text = "│" },
            untracked = { text = "┆" },
        },
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        numhl = false, -- Toggle with `:Gitsigns toggle_nunhl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        sign_priority = 9,
        watch_gitdir = {
            interval = 1000,
        },
        attach_to_untracked = false,
        on_attach = function(bufnr)
            vim.keymap.set("n", "[c", require("gitsigns").prev_hunk, { buffer = bufnr, desc = "Go to Previous Hunk" })
            vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Go to Next Hunk" })
            vim.keymap.set(
                "n",
                "<leader>ph",
                require("gitsigns").preview_hunk,
                { buffer = bufnr, desc = "[P]review [H]unk" }
            )
        end,
    },
}
