Util.au.cmd({ "FocusGained", "TermClose", "TermLeave" }, {
    desc = "Reload file if changed",
    group = Util.au.group("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
    end,
})

Util.au.cmd("TextYankPost", {
    desc = "Highlight on yank",
    group = Util.au.group("highlight_yank"),
    callback = function() vim.hl.on_yank() end,
})

Util.au.cmd("FileType", {
    desc = "Close certain filetypes with <q>",
    group = Util.au.group("close_with_q"),
    -- stylua: ignore
    pattern = {
        "checkhealth", "dbout", "git", "help", "lspinfo", "qf", "fugitive",
        "notify", "startuptime", "tsplayground", "fugitiveblame"
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            Util.map.n("q", function()
                -- vim.cmd.close()
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, "Close buffer", { buffer = event.buf })
        end)
    end,
})

Util.au.cmd("BufWinEnter", {
    desc = "Open help buffers in a vsplit",
    group = Util.au.group("help_window_right"),
    pattern = { "*.txt" },
    callback = function()
        if vim.o.filetype == "help" then vim.cmd.wincmd("L") end
    end,
})
