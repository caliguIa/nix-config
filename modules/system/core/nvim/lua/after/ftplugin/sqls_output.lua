local function first_nonspace_after(line, sep_start)
    local i = sep_start + 3 -- skip 3 bytes of │
    while i <= #line do
        if line:sub(i, i) ~= ' ' then return i end
        i = i + 1
    end
    return sep_start + 3
end

local function get_separators(line)
    local separators = {}
    local bcol = 0
    for char in line:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
        if char == '│' then table.insert(separators, bcol + 1) end
        bcol = bcol + #char
    end
    return separators
end

vim.keymap.set('n', 'l', function()
    local cur_bcol = vim.fn.col('.') -- 1-indexed
    local row = vim.fn.line('.')
    local line = vim.api.nvim_get_current_line()
    local separators = get_separators(line)
    for i, sep_start in ipairs(separators) do
        local target = first_nonspace_after(line, sep_start)
        if target > cur_bcol and i < #separators then
            vim.api.nvim_win_set_cursor(0, { row, target - 1 }) -- 0-indexed
            vim.cmd('normal! zs')
            return
        end
    end
end, { buffer = true, silent = true })

vim.keymap.set('n', 'h', function()
    local cur_bcol = vim.fn.col('.') -- 1-indexed
    local row = vim.fn.line('.')
    local line = vim.api.nvim_get_current_line()
    local separators = get_separators(line)
    for i = #separators, 1, -1 do
        local target = first_nonspace_after(line, separators[i])
        if target < cur_bcol then
            vim.api.nvim_win_set_cursor(0, { row, target - 1 }) -- 0-indexed
            return
        end
    end
end, { buffer = true, silent = true })
