require('mini.git').setup()

local blame_ns = vim.api.nvim_create_namespace('git_blame_highlights')

local function setup_blame_highlights()
    vim.api.nvim_set_hl(0, 'GitBlameDate', { fg = '#6c7086', italic = true })

    local user_colors = {
        '#f38ba8',
        '#f9e2af',
        '#a6e3a1',
        '#89b4fa',
        '#cba6f7',
        '#fab387',
        '#f5c2e7',
        '#94e2d5',
    }

    for i, color in ipairs(user_colors) do
        vim.api.nvim_set_hl(0, 'GitBlameUser' .. i, { fg = color, bold = true })
    end

    local hash_colors = {
        '#89dceb',
        '#b4befe',
        '#eba0ac',
        '#f2cdcd',
        '#ddb6f2',
        '#f5e0dc',
        '#a6adc8',
        '#bac2de',
    }

    for i, color in ipairs(hash_colors) do
        vim.api.nvim_set_hl(0, 'GitBlameHash' .. i, { fg = color })
    end
end

local function hash_string(str)
    local hash = 0
    for i = 1, #str do
        hash = (hash * 31 + string.byte(str, i)) % 2147483647
    end
    return hash
end

vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniGitCommandSplit',
    callback = function(au_data)
        if au_data.data.git_subcommand ~= 'blame' then return end
        print('youre a legend')

        setup_blame_highlights()

        local win_src = au_data.data.win_source
        vim.wo.wrap = false
        vim.fn.winrestview({ topline = vim.fn.line('w0', win_src) })
        vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local formatted_lines = {}

        local blame_pattern = '^(%w+)%s+[^%(]*%((.-)%s+(%d%d%d%d%-%d%d%-%d%d)'
        local uncommitted_pattern = '^000+%s+Not Committed Yet'

        for _, line in ipairs(lines) do
            local formatted_line

            if line:match(uncommitted_pattern) then
                formatted_line = 'Uncommitted'
            else
                local hash, author, date = line:match(blame_pattern)
                if hash and author and date then
                    -- Trim trailing whitespace from author name
                    author = author:gsub('%s+$', '')
                    formatted_line = string.format('%s %s %s', hash, author, date)
                else
                    formatted_line = line
                end
            end

            table.insert(formatted_lines, formatted_line)
        end

        local editor_width = vim.o.columns
        local blame_width = math.floor(editor_width * 0.20)
        vim.api.nvim_win_set_width(0, blame_width)

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_lines)

        vim.api.nvim_buf_clear_namespace(buf, blame_ns, 0, -1)

        for line_num, line in ipairs(formatted_lines) do
            local line_idx = line_num - 1
            local line_length = #line

            if line == 'Uncommitted' then
                vim.api.nvim_buf_set_extmark(buf, blame_ns, line_idx, 0, {
                    end_col = line_length,
                    hl_group = 'GitBlameDate',
                })
            else
                -- Updated pattern to match the formatted line structure and capture full author names
                local hash, author, date = line:match('^(%w+)%s+(.-)%s+(%d%d%d%d%-%d%d%-%d%d.*)')
                if hash and author and date then
                    local hash_color_idx = (hash_string(hash) % 8) + 1
                    local hash_end = math.min(#hash, line_length)
                    vim.api.nvim_buf_set_extmark(buf, blame_ns, line_idx, 0, {
                        end_col = hash_end,
                        hl_group = 'GitBlameHash' .. hash_color_idx,
                    })

                    local user_color_idx = (hash_string(author) % 8) + 1
                    local author_start = #hash + 1
                    local author_end = math.min(author_start + #author, line_length)
                    if author_start < line_length then
                        vim.api.nvim_buf_set_extmark(buf, blame_ns, line_idx, author_start, {
                            end_col = author_end,
                            hl_group = 'GitBlameUser' .. user_color_idx,
                        })
                    end

                    local date_start = #hash + 1 + #author + 1
                    if date_start < line_length then
                        vim.api.nvim_buf_set_extmark(buf, blame_ns, line_idx, date_start, {
                            end_col = line_length,
                            hl_group = 'GitBlameDate',
                        })
                    end
                end
            end
        end

        vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
    end,
})

local function git_blame()
    local curPath = vim.fn.expand('%:p')
    local platform_prefix = curPath:match('/ous/') and 'platform/' or ''
    vim.cmd(':vertical lefta Git blame -- ' .. platform_prefix .. '%')
end
Util.map.nl('gb', git_blame, 'Blame')
