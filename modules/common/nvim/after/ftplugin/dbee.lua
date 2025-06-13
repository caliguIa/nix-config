local function is_valid_json(str)
    -- Remove any leading/trailing whitespace
    str = str:match('^%s*(.-)%s*$')

    -- Try to decode the JSON
    local success, decoded = pcall(vim.json.decode, str)
    if not success then
        return false, decoded -- decoded will contain the error message in this case
    end

    -- Re-encode the JSON to ensure proper formatting
    local success2, encoded = pcall(vim.json.encode, decoded)
    if not success2 then return false, encoded end

    return true, encoded
end

local function create_insert_query()
    -- Get all lines in the buffer
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- Extract header line and data lines
    local header_line = lines[1]
    local data_lines = {}
    for i = 3, #lines do -- Start from line 3 to skip the separator line
        if lines[i] ~= '' then table.insert(data_lines, lines[i]) end
    end

    -- Parse column names from header
    local columns = {}
    for col in header_line:gmatch('│%s*([^│]+)%s*') do
        table.insert(columns, col:match('^%s*(.-)%s*$')) -- Trim whitespace
    end

    -- Build INSERT statement
    local table_name = vim.fn.input('Enter table name: ')
    local insert_query = string.format('INSERT INTO %s (%s)\nVALUES\n', table_name, table.concat(columns, ', '))

    -- Track any JSON validation errors
    local json_errors = {}

    -- Process each data line
    local values = {}
    for line_num, line in ipairs(data_lines) do
        local row_values = {}
        local col_index = 1
        for value in line:gmatch('│%s*([^│]+)%s*') do
            value = value:match('^%s*(.-)%s*$') -- Trim whitespace

            if value == '<nil>' then
                table.insert(row_values, 'NULL')
            else
                -- Check if the value looks like JSON
                local is_json = value:match('^%s*{.*}%s*$') or value:match('^%s*%[.*%]%s*$')

                if is_json then
                    -- Validate and format JSON
                    local valid, result = is_valid_json(value)
                    if valid then
                        -- Use the properly formatted JSON
                        result = result:gsub("'", "''") -- Escape single quotes
                        table.insert(row_values, string.format("CAST('%s' AS JSON)", result))
                    else
                        -- Record the error
                        table.insert(
                            json_errors,
                            string.format(
                                'Invalid JSON at line %d, column %s:\nError: %s\nValue: %s',
                                line_num,
                                columns[col_index],
                                tostring(result),
                                value:sub(1, 50) .. (value:len() > 50 and '...' or '')
                            )
                        )
                        -- Insert NULL for invalid JSON
                        table.insert(row_values, 'NULL')
                    end
                else
                    -- Regular string handling
                    value = value:gsub("'", "''")
                    table.insert(row_values, string.format("'%s'", value))
                end
            end
            col_index = col_index + 1
        end
        table.insert(values, '(' .. table.concat(row_values, ', ') .. ')')
    end

    -- If there were any JSON validation errors, display them
    if #json_errors > 0 then
        vim.api.nvim_echo({
            { 'JSON Validation Errors:\n', 'ErrorMsg' },
            { table.concat(json_errors, '\n\n'), 'ErrorMsg' },
        }, true, {})

        -- Ask user if they want to continue
        local continue = vim.fn.confirm('Would you like to continue with NULL values for invalid JSON?', '&Yes\n&No', 2)
        if continue ~= 1 then
            print('Operation cancelled')
            return
        end
    end

    -- Complete the INSERT statement
    insert_query = insert_query .. table.concat(values, ',\n') .. ';'

    -- Copy to clipboard
    vim.fn.setreg('+', insert_query)
    print('INSERT query copied to clipboard!')
end

Util.map.nl('dc', create_insert_query, 'Copy result as insert query', { buffer = true })
