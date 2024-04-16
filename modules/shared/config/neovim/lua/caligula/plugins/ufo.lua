return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    event = "BufReadPost",
    config = function()
        require("ufo").setup({
            provider_selector = function(_, _, _)
                return { "lsp", "indent" }
            end,
        })

        local keymap = vim.keymap

        keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
        keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
        keymap.set("n", "zK", function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then
                vim.lsp.buf.hover()
            end
        end, { desc = "Peek folded lines under cursor" })
    end,
}
