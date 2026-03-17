local state = {
    has_command = false,
    commands_cache = nil,
}

local config = {
    window = { width_ratio = 0.3 },
    docker = { service_name = 'platform' },
}

---@return string|nil
local function find_artisan_path()
    local current_dir = vim.fn.getcwd()
    local prev_dir = ''
    while current_dir ~= prev_dir do
        local path = current_dir .. '/artisan'
        if vim.fn.filereadable(path) == 1 then return path end
        prev_dir = current_dir
        current_dir = vim.fn.fnamemodify(current_dir, ':h')
    end
end

---@param laravel_path string
---@return string
local function cache_path(laravel_path)
    local key = laravel_path:gsub('[/\\]', '_'):gsub('^_', '')
    return vim.fn.stdpath('cache') .. '/artisan/' .. key .. '.json'
end

---@param laravel_path string
---@return table|nil
local function read_cache(laravel_path)
    local path = cache_path(laravel_path)
    if vim.fn.filereadable(path) ~= 1 then return nil end
    local ok, data = pcall(vim.fn.readfile, path)
    if not ok then return nil end
    local ok2, decoded = pcall(vim.json.decode, table.concat(data, '\n'))
    -- Validate format: must be a non-empty list of objects (not legacy flat strings)
    if not ok2 or type(decoded) ~= 'table' or #decoded == 0 or type(decoded[1]) ~= 'table' then return nil end
    return decoded
end

---@param laravel_path string
---@param commands table
local function write_cache(laravel_path, commands)
    local dir = vim.fn.stdpath('cache') .. '/artisan'
    if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
    local ok, encoded = pcall(vim.json.encode, commands)
    if ok then vim.fn.writefile({ encoded }, cache_path(laravel_path)) end
end

---@param laravel_path string
---@return table
local function build_artisan_cmd(laravel_path)
    local has_compose = false
    for _, f in ipairs({ 'docker-compose.yml', 'docker-compose.yaml' }) do
        if vim.fn.filereadable(laravel_path .. '/' .. f) == 1 then
            has_compose = true
            break
        end
    end

    if not has_compose then return { 'php', vim.fn.shellescape(laravel_path .. '/artisan') } end

    local compose = vim.system({ 'docker', 'compose', '--version' }, { text = true }):wait().code == 0
            and { 'docker', 'compose' }
        or { 'docker-compose' }
    local tty = vim.fn.has('tty') == 1 and '' or '-T'
    return vim.list_extend(compose, { 'exec', tty, config.docker.service_name, 'php', 'artisan' })
end

---@param laravel_path string
---@return table  list of { name, desc, has_args }
local function fetch_commands(laravel_path)
    local cmd = vim.list_extend(build_artisan_cmd(laravel_path), { 'list', '--format=json' })
    local output = vim.system(cmd, { text = true, stderr = false }):wait().stdout
    local ok, decoded = pcall(vim.json.decode, output)
    if not ok or not decoded.commands then return {} end

    local result = {}
    for _, c in ipairs(decoded.commands) do
        if c.name ~= '_complete' and c.name ~= 'completion' then
            local has_args = false
            for arg_name in pairs((c.definition or {}).arguments or {}) do
                if arg_name ~= 'command' then
                    has_args = true
                    break
                end
            end
            result[#result + 1] = { name = c.name, desc = c.description, has_args = has_args }
        end
    end
    return result
end

---@param laravel_path string
---@return table
local function get_commands(laravel_path)
    local cached = read_cache(laravel_path)
    if cached then return cached end
    local commands = fetch_commands(laravel_path)
    if #commands > 0 then write_cache(laravel_path, commands) end
    return commands
end

---@param laravel_path string
local function refresh_commands(laravel_path)
    state.commands_cache = nil
    local p = cache_path(laravel_path)
    if vim.fn.filereadable(p) == 1 then vim.fn.delete(p) end
    vim.notify('artisan: refreshing...', vim.log.levels.INFO)
    local commands = fetch_commands(laravel_path)
    if #commands == 0 then
        vim.notify('artisan: no commands found, cache unchanged', vim.log.levels.WARN)
        return
    end
    write_cache(laravel_path, commands)
    state.commands_cache = commands
    vim.notify(('artisan: cached %d commands'):format(#commands), vim.log.levels.INFO)
end

---@param opts table
local function run_command(opts)
    local artisan_path = find_artisan_path()
    if not artisan_path then
        vim.notify('artisan: not found — are you in a Laravel project?', vim.log.levels.ERROR)
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.api.nvim_get_option_value('columns', {}) * config.window.width_ratio)
    local win = vim.api.nvim_open_win(buf, true, { split = 'right', width = width, win = 0 })

    vim.api.nvim_set_option_value('buflisted', false, { buf = buf })
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
    vim.api.nvim_set_option_value('number', false, { win = win })
    vim.api.nvim_set_option_value('relativenumber', false, { win = win })
    vim.api.nvim_set_option_value('cursorline', false, { win = win })

    local cmd = vim.list_extend(build_artisan_cmd(vim.fn.fnamemodify(artisan_path, ':h')), opts.fargs)
    vim.fn.jobstart(cmd, { term = true })

    vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, {
        buffer = buf,
        silent = true,
        desc = 'Close Artisan terminal',
    })
end

---@param laravel_path string
local function open_picker(laravel_path)
    if not state.commands_cache then state.commands_cache = get_commands(laravel_path) end
    if #state.commands_cache == 0 then
        vim.notify('artisan: no commands found', vim.log.levels.ERROR)
        return
    end

    vim.ui.select(state.commands_cache, {
        prompt = 'Artisan',
        format_item = function(item) return item.name .. ' - ' .. item.desc end,
    }, function(choice)
        if not choice then return end
        if choice.has_args then
            vim.api.nvim_feedkeys(':Artisan ' .. choice.name .. ' ', 'n', false)
        else
            run_command({ fargs = { choice.name } })
        end
    end)
end

local function setup()
    local artisan_path = find_artisan_path()
    local is_laravel = artisan_path ~= nil
        and vim.fn.filereadable(vim.fn.fnamemodify(artisan_path, ':h') .. '/composer.json') == 1

    if is_laravel and not state.has_command then
        local lpath = vim.fn.fnamemodify(artisan_path, ':h')
        state.commands_cache = get_commands(lpath)

        vim.api.nvim_create_user_command('Artisan', run_command, {
            desc = 'Run an Artisan command',
            nargs = '*',
            complete = function()
                if not state.commands_cache then state.commands_cache = get_commands(lpath) end
                return vim.tbl_map(function(e) return e.name end, state.commands_cache)
            end,
        })
        vim.api.nvim_create_user_command('ArtisanPicker', function() open_picker(lpath) end, {
            desc = 'Pick and run an Artisan command',
        })
        vim.api.nvim_create_user_command('ArtisanRefresh', function() refresh_commands(lpath) end, {
            desc = 'Refresh the Artisan command cache',
        })

        vim.keymap.set('n', '<leader>la', vim.cmd.ArtisanPicker, { desc = 'Artisan commands', silent = true })
        state.has_command = true
    elseif not is_laravel and state.has_command then
        for _, c in ipairs({ 'Artisan', 'ArtisanPicker', 'ArtisanRefresh' }) do
            pcall(vim.api.nvim_del_user_command, c)
        end
        state.commands_cache = nil
        state.has_command = false
    end
end

setup()
