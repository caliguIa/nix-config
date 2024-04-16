local diagnostics_icons = require("caligula.core.icons").diagnostics

local diagnostics = {
    "diagnostics",
    sections = { "error", "warn" },
    colored = true, -- Displays diagnostics status in color if set to true.
    always_visible = true, -- Show diagnostics even if there are none.
    symbols = {
        error = diagnostics_icons.ERROR,
        warn = diagnostics_icons.WARN,
        hint = diagnostics_icons.HINT,
        info = diagnostics_icons.INFO,
    },
}

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "AndreM222/copilot-lualine",
    },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status") -- to configure lazy pending updates count

        lualine.setup({
            options = {
                icons_enabled = false,
                theme = "kanagawa",
                disabled_filetypes = { "oil" },
                component_separators = "",
                section_separators = "",
            },
            extensions = { "trouble" },
            sections = {
                lualine_a = { "branch" },
                lualine_b = {},
                lualine_c = {
                    {
                        "filename",
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                    },
                },
                lualine_x = {
                    "progress",
                    { lazy_status.updates, cond = lazy_status.has_updates },
                    "copilot",
                    "diff",
                    diagnostics,
                },
                lualine_y = {},
                lualine_z = {},
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        "filename",
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                    },
                },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
        })
    end,
}
