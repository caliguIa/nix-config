local icon = require("caligula.core.icons").misc.circle

return {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
        require("nvim-highlight-colors").setup({
            render = "virtual",
            virtual_symbol = icon,
            enable_tailwind = true,
        })
    end,
}
