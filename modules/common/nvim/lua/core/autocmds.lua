-- Check if we need to reload the file when it changed
Util.au.cmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = Util.au.group("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
    end,
})

-- Highlight on yank
Util.au.cmd("TextYankPost", {
    group = Util.au.group("highlight_yank"),
    callback = function() vim.hl.on_yank() end,
})

-- close some filetypes with <q>
Util.au.cmd("FileType", {
    group = Util.au.group("close_with_q"),
    -- stylua: ignore
    pattern = {
        "checkhealth", "dbout", "git", "help", "lspinfo",
        "notify", "qf", "startuptime", "tsplayground"
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            Util.map.n("q", function()
                vim.cmd.close()
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, "Close buffer", { buffer = event.buf })
        end)
    end,
})

-- Make help buffers open in vertical split
Util.au.cmd("BufWinEnter", {
    group = Util.au.group("help_window_right"),
    pattern = { "*.txt" },
    callback = function()
        if vim.o.filetype == "help" then vim.cmd.wincmd("L") end
    end,
})

Util.au.cmd({ "UIEnter" }, {
    group = Util.au.group("firenvim"),
    callback = function()
        local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
        if client and client.name == "Firenvim" then
            vim.g.hanzel_disable = true
            vim.o.cmdheight = 0
            vim.o.laststatus = 0
            vim.o.scrolloff = 0
            vim.o.shortmess = "ltToOCFW"
            vim.o.textwidth = 9999
            vim.o.winbar = nil
        end
    end,
})
