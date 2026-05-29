vim.opt_local.commentstring = '-- %s'

-- Get the sqls LSP client attached to the current buffer
local function get_sqls_client()
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if client.name == 'sqls' then return client end
    end
end

-- Get the treesitter node range for the statement under cursor
local function get_statement_range()
    local node = vim.treesitter.get_node()
    while node do
        if node:type() == 'statement' then
            local srow, _, erow, ecol = node:range()
            return srow, erow, ecol
        end
        node = node:parent()
    end
end

local function get_table_name()
    local node = vim.treesitter.get_node()
    while node do
        if node:type() == 'relation' then return vim.treesitter.get_node_text(node, 0) end
        node = node:parent()
    end
    -- fallback: walk the statement node's children for any relation
    local stmt_node = vim.treesitter.get_node()
    while stmt_node and stmt_node:type() ~= 'statement' do
        stmt_node = stmt_node:parent()
    end
    if stmt_node then
        for child in stmt_node:iter_children() do
            if child:type() == 'relation' then return vim.treesitter.get_node_text(child, 0) end
        end
    end
    return nil
end

local active_connection = nil

local function parse_connection(line)
    -- extract the db name after the last /
    local db = line:match('/([^/\n]+)$')
    local driver = line:match('^%d+ (%S+)')
    if db and driver then return driver .. '/' .. db end
    return line
end

local function show_connection_float(win)
    if not active_connection then return end
    local label = ' 󱘖 ' .. active_connection .. ' '
    local win_width = vim.api.nvim_win_get_width(win)
    local float_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(float_bufnr, 0, -1, false, { label })
    vim.api.nvim_set_hl(0, 'SqlsConnection', { link = 'FloatBorder' })
    vim.api.nvim_open_win(float_bufnr, false, {
        relative = 'win',
        win = win,
        row = 0,
        col = win_width - #label - 1,
        width = #label,
        height = 1,
        style = 'minimal',
        focusable = false,
    })
    vim.api.nvim_buf_call(float_bufnr, function() vim.fn.matchadd('SqlsConnection', '.*') end)
end

local function init_connection()
    local client = get_sqls_client()
    if not client then return end
    client:request('workspace/executeCommand', { command = 'showConnections' }, function(err, result)
        if err or not result then return end
        -- default to first connection
        local first = result:match('^[^\n]+')
        if first then active_connection = parse_connection(first) end
        vim.schedule(function() show_connection_float(vim.api.nvim_get_current_win()) end)
    end)
end

vim.api.nvim_create_autocmd('LspAttach', {
    pattern = { '*.sql' },
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'sqls' then vim.schedule(function() init_connection() end) end
    end,
})

-- Execute the SQL statement under the cursor
vim.keymap.set('n', '<C-CR>', function()
    local client = get_sqls_client()
    if not client then
        vim.notify('sqls: no LSP client attached', vim.log.levels.WARN)
        return
    end

    local srow, erow, ecol = get_statement_range()
    if not srow then
        vim.notify('sqls: no statement found under cursor', vim.log.levels.WARN)
        return
    end

    local table_name = get_table_name()

    local range =
        vim.lsp.util.make_given_range_params({ srow + 1, 0 }, { erow + 1, ecol }, 0, client.offset_encoding).range

    client:request('workspace/executeCommand', {
        command = 'executeQuery',
        arguments = { vim.uri_from_bufnr(0) },
        range = range,
    }, function(err, result)
        if err then
            vim.notify('sqls: ' .. err.message, vim.log.levels.ERROR)
            return
        end
        if not result then return end
        local tempfile = vim.fn.tempname() .. '.sqls_output'
        local bufnr = vim.fn.bufnr(tempfile, true)
        vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, vim.split(result, '\n'))
        vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
        vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
        vim.cmd.pedit({ args = { tempfile } })
        vim.api.nvim_set_option_value('filetype', 'sqls_output', { buf = bufnr })

        vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == bufnr then
                    local height = math.floor(vim.o.lines * 0.7)
                    vim.api.nvim_win_set_height(win, height)

                    vim.api.nvim_set_option_value('number', false, { win = win })
                    vim.api.nvim_set_option_value('relativenumber', false, { win = win })
                    vim.api.nvim_set_option_value('signcolumn', 'no', { win = win })
                    vim.api.nvim_set_option_value('foldcolumn', '0', { win = win })
                    vim.api.nvim_set_option_value('cursorline', false, { win = win })

                    -- strip last 4 lines and grab row count
                    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                    local row_count = nil
                    for i = #lines, math.max(1, #lines - 3), -1 do
                        local match = lines[i]:match('^(%d+) rows? in set')
                        if match then
                            row_count = match
                            break
                        end
                    end
                    vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
                    vim.api.nvim_buf_set_lines(bufnr, -5, -1, false, {})
                    vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })

                    -- build statusline
                    local status = 'sqls'
                    if table_name then status = status .. ' · table: ' .. table_name end
                    if row_count then status = status .. ' · ' .. row_count .. ' rows' end
                    vim.api.nvim_set_option_value('statusline', status, { win = win })

                    vim.api.nvim_set_option_value('filetype', 'sqls_output', { buf = bufnr })
                    vim.api.nvim_set_hl(0, 'SqlsBorder', { link = 'FloatBorder' })
                    vim.api.nvim_set_hl(0, 'SqlsHeader', { link = 'Title' })
                    vim.api.nvim_buf_call(bufnr, function()
                        vim.fn.matchadd('SqlsBorder', '[│─┌┐└┘├┤┬┴┼]')
                        vim.fn.matchadd('SqlsHeader', '\\%2l[^ │─┌┐└┘├┤┬┴┼]')
                    end)

                    break
                end
            end
        end)
    end)
end, { desc = 'Run query under cursor', silent = true, buffer = true })

vim.keymap.set('n', '<Leader>sc', function()
    local client = get_sqls_client()
    if not client then return end
    client:request('workspace/executeCommand', { command = 'showConnections' }, function(err, result)
        if err or not result or result == '' then return end
        local choices = vim.split(result, '\n')
        vim.ui.select(choices, { prompt = 'sqls: switch connection' }, function(answer)
            if not answer then return end
            local index = answer:match('^(%d+)')
            client:request('workspace/executeCommand', {
                command = 'switchConnections',
                arguments = { index },
            }, function(switch_err)
                if switch_err then
                    vim.notify('sqls: ' .. switch_err.message, vim.log.levels.ERROR)
                    return
                end
                active_connection = parse_connection(answer)
                vim.schedule(function() show_connection_float(vim.api.nvim_get_current_win()) end)
            end)
        end)
    end)
end, { desc = 'Switch sqls connection', buffer = true })
