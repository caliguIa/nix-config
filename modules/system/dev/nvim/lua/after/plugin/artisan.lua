-- Thin wrapper around the `artisan` shell program (modules/system/gui/artisan),
-- which finds the project, picks docker compose vs host php and caches commands.

local state = {
    has_command = false,
    commands_cache = nil,
    -- Bumped on refresh so in-flight results from before it are discarded.
    generation = 0,
}

local config = {
    window = { width_ratio = 0.3 },
}

-- Same lookup as the shell (works from a monorepo root above the project).
---@return boolean
local function in_laravel_project()
    if vim.fn.executable('artisan') ~= 1 then return false end
    return vim.system({ 'artisan', '--root' }, { stderr = false }):wait().code == 0
end

---@param result vim.SystemCompleted
---@return table|nil  list of { name, desc, has_args }
local function decode_commands(result)
    if result.code ~= 0 then return nil end
    local ok, decoded = pcall(vim.json.decode, result.stdout)
    if not ok or type(decoded) ~= 'table' or #decoded == 0 then return nil end
    return decoded
end

---@return table
local function get_commands()
    if not state.commands_cache then
        local result = vim.system({ 'artisan', '--commands', '--json' }, { text = true }):wait()
        -- Cache failures as {} too, so a dead container doesn't block every <Tab>.
        state.commands_cache = decode_commands(result) or {}
    end
    return state.commands_cache
end

-- Populate the cache in the background so the first picker/completion is instant.
local function warm_commands()
    local generation = state.generation
    vim.system({ 'artisan', '--commands', '--json' }, { text = true }, function(result)
        local commands = decode_commands(result)
        if not commands then return end
        vim.schedule(function()
            if state.generation == generation then state.commands_cache = state.commands_cache or commands end
        end)
    end)
end

local function refresh_commands()
    state.generation = state.generation + 1
    state.commands_cache = nil
    vim.notify('artisan: refreshing...', vim.log.levels.INFO)
    vim.system({ 'artisan', '--refresh' }, { text = true }, function(result)
        vim.schedule(function()
            -- Anything read while the refresh ran came from the old cache file.
            state.commands_cache = nil
            if result.code ~= 0 then
                vim.notify(vim.trim(result.stderr), vim.log.levels.WARN)
                return
            end
            vim.notify(vim.trim(result.stdout), vim.log.levels.INFO)
        end)
    end)
end

---@param opts table
local function run_command(opts)
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.api.nvim_get_option_value('columns', {}) * config.window.width_ratio)
    local win = vim.api.nvim_open_win(buf, true, { split = 'right', width = width, win = 0 })

    vim.api.nvim_set_option_value('buflisted', false, { buf = buf })
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
    vim.api.nvim_set_option_value('number', false, { win = win })
    vim.api.nvim_set_option_value('relativenumber', false, { win = win })
    vim.api.nvim_set_option_value('cursorline', false, { win = win })

    vim.fn.jobstart(vim.list_extend({ 'artisan' }, opts.fargs), { term = true })

    vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, {
        buffer = buf,
        silent = true,
        desc = 'Close Artisan terminal',
    })
end

local function open_picker()
    local commands = get_commands()
    if #commands == 0 then
        vim.notify('artisan: no commands found', vim.log.levels.ERROR)
        return
    end

    vim.ui.select(commands, {
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
    local is_laravel = in_laravel_project()

    if is_laravel and not state.has_command then
        warm_commands()

        vim.api.nvim_create_user_command('Artisan', run_command, {
            desc = 'Run an Artisan command',
            nargs = '*',
            complete = function() return vim.tbl_map(function(e) return e.name end, get_commands()) end,
        })
        vim.api.nvim_create_user_command('ArtisanPicker', open_picker, {
            desc = 'Pick and run an Artisan command',
        })
        vim.api.nvim_create_user_command('ArtisanRefresh', refresh_commands, {
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
