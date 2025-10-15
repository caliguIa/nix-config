local state = {
    has_command = false,
    commands_cache = nil,
}

local config = {
    window = {
        width_ratio = 0.3, -- Width as a ratio of the editor width
    },
    docker = {
        service_name = 'platform', -- Default Docker service name
    },
}

---Find the artisan file by traversing up the directory tree
---@return string|nil artisan_path The full path to artisan or nil if not found
local function find_artisan_path()
    local current_dir = vim.fn.getcwd()
    local prev_dir = ''

    while current_dir ~= prev_dir do
        local artisan_path = current_dir .. '/artisan'
        if vim.fn.filereadable(artisan_path) == 1 then return artisan_path end

        prev_dir = current_dir
        current_dir = vim.fn.fnamemodify(current_dir, ':h')
    end

    return nil
end

---Determine the appropriate Docker Compose command
---@return table -- The docker compose command to use
local function get_docker_compose_cmd()
    local result = vim.system({ 'docker', 'compose', '--version' }, { text = true }):wait()
    if result.code == 0 then return { 'docker', 'compose' } end

    return { 'docker-compose' }
end

---Build the artisan command based on environment detection
---@param laravel_path string The path to the Laravel project root
---@return table -- The full artisan command to execute
local function build_artisan_cmd(laravel_path)
    local artisan_path = laravel_path .. '/artisan'
    local docker_compose_file = nil

    -- Check for docker-compose files
    for _, filename in ipairs({ 'docker-compose.yml', 'docker-compose.yaml' }) do
        if vim.fn.filereadable(laravel_path .. '/' .. filename) == 1 then
            docker_compose_file = laravel_path .. '/' .. filename
            break
        end
    end

    -- Use direct PHP if no Docker setup found
    if not docker_compose_file then return { 'php', vim.fn.shellescape(artisan_path) } end

    local docker_compose_cmd = get_docker_compose_cmd()
    local tty_flag = vim.fn.has('tty') == 1 and '' or '-T'

    return vim.list_extend(docker_compose_cmd, { 'exec', tty_flag, config.docker.service_name, 'php', 'artisan' })
end

---Get all available artisan commands for the current project
---@return table -- A list of available artisan commands
local function get_artisan_commands()
    local artisan_path = find_artisan_path()
    if not artisan_path then return {} end

    local laravel_path = vim.fn.fnamemodify(artisan_path, ':h')
    local artisan_cmd = build_artisan_cmd(laravel_path)

    local artisan_list_cmd = vim.list_extend(artisan_cmd, { 'list', '--format=json', '--short' })
    local output = vim.system(artisan_list_cmd, { text = true, stderr = false }):wait().stdout

    local success, decoded = pcall(vim.json.decode, output)
    if not success or not decoded.commands then return {} end

    -- Filter out special commands
    local filtered_commands = {}
    for _, cmd_data in ipairs(decoded.commands) do
        local command_name = cmd_data.name
        if command_name ~= '_complete' and command_name ~= 'completion' then
            table.insert(filtered_commands, command_name)
        end
    end

    return filtered_commands
end

---Run an artisan command in a terminal split
---@param opts table Command options from nvim_create_user_command
local function execute_artisan_command(opts)
    local artisan_path = find_artisan_path()
    if not artisan_path then
        vim.notify('artisan: artisan not found. Are you in a Laravel directory?', vim.log.levels.ERROR)
        return
    end

    local laravel_path = vim.fn.fnamemodify(artisan_path, ':h')
    local artisan_cmd = build_artisan_cmd(laravel_path)

    local buf = vim.api.nvim_create_buf(false, true)

    local win_width = vim.api.nvim_get_option_value('columns', {})
    local term_width = math.floor(win_width * config.window.width_ratio)

    local win = vim.api.nvim_open_win(buf, true, {
        width = term_width,
        split = 'right',
        win = 0,
    })

    vim.api.nvim_set_option_value('buflisted', false, { buf = buf })
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

    vim.api.nvim_set_option_value('number', false, { win = win })
    vim.api.nvim_set_option_value('relativenumber', false, { win = win })
    vim.api.nvim_set_option_value('cursorline', false, { win = win })

    local cmd = vim.list_extend(artisan_cmd, opts.fargs)
    vim.fn.jobstart(cmd, { term = true })

    vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, {
        buffer = buf,
        silent = true,
        desc = 'Close the Artisan terminal',
    })
end

---Open a picker to select and run Artisan commands
local function open_artisan_picker()
    local artisan_path = find_artisan_path()
    if not artisan_path then
        vim.notify('artisan: artisan not found. Are you in a Laravel directory?', vim.log.levels.ERROR)
        return
    end

    if not state.commands_cache then state.commands_cache = get_artisan_commands() end

    if #state.commands_cache == 0 then
        vim.notify('No Artisan commands found', vim.log.levels.ERROR)
        return
    end

    vim.ui.select(state.commands_cache, {
        prompt = 'Select Artisan command:',
        format_item = function(item) return item end,
    }, function(choice)
        if not choice then return end
        execute_artisan_command({ fargs = vim.split(choice, ' ') })
    end)
end

---Check if the current directory is a Laravel project and setup the command
local function setup_artisan_command()
    local artisan_path = find_artisan_path()
    local is_laravel_project = artisan_path ~= nil
        and vim.fn.filereadable(vim.fn.fnamemodify(artisan_path, ':h') .. '/composer.json') == 1

    if is_laravel_project and not state.has_command then
        -- Create the Artisan user command
        vim.api.nvim_create_user_command('Artisan', execute_artisan_command, {
            desc = 'Run Artisan commands in a terminal split',
            nargs = '*',
            complete = function()
                if not state.commands_cache then state.commands_cache = get_artisan_commands() end
                return state.commands_cache
            end,
        })

        -- Create the Artisan picker command
        vim.api.nvim_create_user_command('ArtisanPicker', open_artisan_picker, {
            desc = 'Open a picker to select and run Artisan commands',
            nargs = 0,
        })

        vim.keymap.set('n', '<leader>la', vim.cmd.ArtisanPicker, { desc = 'Artisan commands', silent = true })

        state.has_command = true
    elseif not is_laravel_project and state.has_command then
        -- Remove the commands if we're no longer in a Laravel project
        pcall(vim.api.nvim_del_user_command, 'Artisan')
        pcall(vim.api.nvim_del_user_command, 'ArtisanPicker')
        state.has_command = false
    end
end

-- Initialize the integration
setup_artisan_command()

-- Command to clear the cached list of Artisan commands
vim.api.nvim_create_user_command('ArtisanCacheClear', function()
    state.commands_cache = nil
    vim.notify('Cleared Artisan command cache')
end, {
    desc = 'Clears the cache of available Artisan commands',
    nargs = 0,
})

-- Update the command when changing directories
vim.api.nvim_create_autocmd('DirChanged', {
    group = vim.api.nvim_create_augroup('artisan-command', { clear = true }),
    callback = setup_artisan_command,
})
