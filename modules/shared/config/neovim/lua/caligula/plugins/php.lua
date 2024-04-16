return {
    -- {
    --     "adalessa/laravel.nvim",
    --     ft = "php",
    --     dependencies = {
    --         "nvim-telescope/telescope.nvim",
    --         "tpope/vim-dotenv",
    --         "MunifTanjim/nui.nvim",
    --     },
    --     cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    --     keys = {
    --         { "<leader>la", ":Laravel artisan<cr>" },
    --         { "<leader>lr", ":Laravel routes<cr>" },
    --         { "<leader>lm", ":Laravel related<cr>" },
    --     },
    --     event = { "VeryLazy" },
    --     config = function()
    --         require("laravel").setup({
    --             lsp_server = "intelephense",
    --             features = {
    --                 null_ls = {
    --                     enable = false,
    --                 },
    --             },
    --         })
    --     end,
    -- },
    {
        "oliverhkraft/nvim-pint",
        config = function()
            require("nvim-pint").setup({
                silent = true,
                exclude_folders = { "resources/views" },
            })
        end,
    },
}
