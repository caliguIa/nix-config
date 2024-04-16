return {
    "stevearc/oil.nvim",
    opts = {},
    config = function()
        require("oil").setup({
            -- vim.api.nvim_create_autocmd("User", {
            --     pattern = "OilEnter",
            --     callback = vim.schedule_wrap(function(args)
            --         local oil = require("oil")
            --         if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
            --             oil.select({ preview = true })
            --         end
            --     end),
            -- }),
            default_file_explorer = true,
            columns = { "icon" },
            win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },
            view_options = {
                show_hidden = true,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>fe", "<CMD>Oil<CR>", { silent = true, desc = "Toggle [F]ile [E]xplorer" })
    end,
}
