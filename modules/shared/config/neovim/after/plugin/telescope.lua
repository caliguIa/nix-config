-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
            },
            n = {
                ["d"] = "delete_buffer",
            },
        },
        path_display = {
            "truncate",
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({
                -- even more opts
            }),
        },
    },
})

-- truncate file paths in find files
-- require("telescope.builtin").find_files({ path_display = { "truncate" } })

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- Enable telescope harpoon fun, if installed
pcall(require("telescope").load_extension, "harpoon")
pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "live_grep_args")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>gb", require("telescope.builtin").git_branches, { desc = "Search [G]it [B]ranches" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch [B]uffers" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
-- vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set(
    "n",
    "<leader>sg",
    ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
    { desc = "[S]earch by [G]rep", silent = true }
)
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
