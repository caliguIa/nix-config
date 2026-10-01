-- nnn as the file manager: opening a file in nnn (picker mode, Enter) quits it
-- and opens that file here; -o keeps `l`/right from xdg-opening files. Oil's
-- buffer-local `-` (parent dir) still wins in oil.
local function nnn()
    local file = vim.api.nvim_buf_get_name(0)
    local dir = file ~= '' and vim.fs.dirname(file) or vim.uv.cwd()
    if not vim.uv.fs_stat(dir) then dir = vim.uv.cwd() end

    local pick = vim.fn.tempname()
    local prev_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        row = 0,
        col = 0,
        width = vim.o.columns,
        height = vim.o.lines - vim.o.cmdheight,
        style = 'minimal',
        border = 'none',
    })

    vim.fn.jobstart({ 'nnn', '-o', '-p', pick, dir }, {
        term = true,
        on_exit = function()
            vim.schedule(function()
                if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
                if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
                local ok, paths = pcall(vim.fn.readfile, pick)
                os.remove(pick)
                if not ok then return end
                if vim.api.nvim_win_is_valid(prev_win) then vim.api.nvim_set_current_win(prev_win) end
                for _, path in ipairs(paths) do
                    if path ~= '' then vim.cmd.edit(vim.fn.fnameescape(path)) end
                end
            end)
        end,
    })
    vim.cmd.startinsert()
end

vim.keymap.set('n', '-', nnn, { desc = 'File manager (nnn)', silent = true })
