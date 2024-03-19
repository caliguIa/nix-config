return {
    { -- "ccaglak/larago.nvim",
        -- dependencies = {
        --     "nvim-lua/plenary.nvim",
        -- },
        -- config = function()
        --     vim.keymap.set("n", "<leader>gb", "<cmd>GoBlade<cr>")
        -- end,
    },
    -- {
    --     "ccaglak/namespace.nvim",
    --     keys = {
    --         { "<leader>na", "<cmd>GetClasses<cr>" },
    --         { "<leader>nc", "<cmd>GetClass<cr>" },
    --         { "<leader>ns", "<cmd>ClassAs<cr>" },
    --         { "<leader>nn", "<cmd>Namespace<cr>" },
    --     },
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --     },
    -- },
    -- {
    --     "ccaglak/phptools.nvim",
    --     keys = {
    --         { "<leader>pm", "<cmd>PhpMethod<cr>" },
    --         { "<leader>pc", "<cmd>PhpClass<cr>" },
    --         { "<leader>ps", "<cmd>PhpScripts<cr>" },
    --         { "<leader>pn", "<cmd>PhpNamespace<cr>" },
    --         { "<leader>pg", "<cmd>PhpGetSet<cr>" },
    --         { "<leader>pa", "<cmd>PhpArtisan<cr>" },
    --         { "<leader>pf", "<cmd>PhpCreate<cr>" },
    --     },
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --     },
    --     config = function()
    --         require("phptools").setup({
    --             ui = false, -- if you have stevearc/dressing.nvim or something similar keep it false or else true
    --         })
    --         vim.keymap.set("v", "<leader>lr", ":PhpRefactor<cr>")
    --     end,
    -- },
    {
        "adalessa/laravel.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "tpope/vim-dotenv",
            "MunifTanjim/nui.nvim",
        },
        cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
        keys = {
            { "<leader>la", ":Laravel artisan<cr>" },
            { "<leader>lr", ":Laravel routes<cr>" },
            { "<leader>lm", ":Laravel related<cr>" },
        },
        event = { "VeryLazy" },
        config = function()
            require("laravel").setup({
                lsp_server = "intelephense",
                features = {
                    null_ls = {
                        enable = false,
                    },
                },
            })
        end,
    },
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
