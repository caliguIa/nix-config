return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status") -- to configure lazy pending updates count

        lualine.setup({
            options = {
                icons_enabled = false,
                theme = "catppuccin",
                component_separators = "|",
                section_separators = "",
            },
            extensions = { "fugitive", "trouble", "oil" },
            sections = {
                lualine_a = { "branch", "diff" },
                lualine_b = { { "filename", file_status = true, path = 1 } },
                lualline_c = {},
                lualine_x = {
                    {
                        "searchcount",
                        {
                            "diagnostics",
                            symbols = { error = " ", warn = " ", hint = "󰠠 ", info = " " },
                        },
                    },
                },
                lualine_y = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                    },
                },
                lualline_z = {
                    {
                        -- "fugitive",
                        -- "trouble",
                        -- "oil",
                        -- "datetime",
                    },
                },
            },
        })
    end,
}
