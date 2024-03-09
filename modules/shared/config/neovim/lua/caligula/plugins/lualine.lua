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
            sections = {
                lualine_c = { { "filename", file_status = true, path = 1 } },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                    },
                    { "encoding" },
                    { "fileformat" },
                    { "filetype" },
                },
            },
        })
    end,
}
