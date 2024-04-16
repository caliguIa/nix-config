local icons = require("caligula.core.icons")

return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = { [[ neobim ]] }

        dashboard.section.buttons.val = {
            dashboard.button("e", string.format("%s - New File", icons.symbol_kinds.File), "<cmd>ene<CR>"),

            dashboard.button(
                "r",
                string.format("%s - Restore session for CWD", icons.symbol_kinds.Folder),
                [[<cmd>lua require("persistence").load()<cr>]]
            ),

            dashboard.button("fe", string.format("%s - File explorer", icons.symbol_kinds.Folder), "<CMD>Oil<CR>"),

            dashboard.button("ff", string.format("%s - Find file", icons.misc.search_files), "<cmd>FzfLua files<cr>"),

            dashboard.button("fg", string.format("%s - Grep", icons.misc.search), "<cmd>FzfLua live_grep_glob<cr>"),

            dashboard.button("q", string.format("%s - Quit", icons.diagnostics.ERROR), "<cmd>qa<CR>"),
        }

        alpha.setup(dashboard.opts)

        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
