_G.Util = {}

---@param mode string Mode to add mapping to
---@param prefix ?string Optional prefix to add to all keys (e.g., "<leader>")
local function create_mapper(mode, prefix)
    prefix = prefix or ''

    ---@param keys string Keys to map
    ---@param cmd function|string Function to call
    ---@param desc ?string Keymap description
    ---@param opts ?table Optional opts table
    return function(keys, cmd, desc, opts)
        vim.keymap.set(
            mode,
            (prefix or '') .. keys,
            cmd,
            vim.tbl_extend('force', { desc = desc, silent = true }, opts or {})
        )
    end
end

_G.Util.map = {
    n = create_mapper('n'), -- Normal mode
    nl = create_mapper('n', '<leader>'), -- Normal mode with leader prefix
    i = create_mapper('i'), -- Insert mode
    v = create_mapper('v'), -- Visual mode
    vl = create_mapper('v', '<leader>'), -- Visual mode with leader prefix
    c = create_mapper('c'), -- Command mode
    x = create_mapper('x'), -- Visual block mode
    xl = create_mapper('x', '<leader>'), -- Visual block mode with leader prefix
}

_G.Util.au = {
    cmd = vim.api.nvim_create_autocmd,
    group = function(name, opts)
        vim.api.nvim_create_augroup(name, vim.tbl_extend('force', { clear = true }, opts or {}))
    end,
}

_G.Util.req = function(modname)
    local ok, err = pcall(require, modname)
    if not ok then vim.notify('Error loading module: ' .. modname .. ' ' .. err, vim.log.levels.ERROR) end
end
