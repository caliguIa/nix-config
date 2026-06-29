require('conflict').setup({
    default_mappings = {
        current = 'co',
        incoming = 'ct',
    },
})

-- Git branch tracking
-- Asynchronously resolves the current git branch and stores it in vim.g.git_branch.
-- The statusline is only redrawn when the branch value actually changes.
vim.g.git_branch = ''

local function update_git_branch()
    local cwd = vim.uv.cwd()
    local output = {}
    vim.fn.jobstart({ 'git', 'branch', '--show-current' }, {
        cwd = cwd,
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then output = data end
        end,
        on_exit = function(_, code)
            local branch = (code == 0 and output[1] and output[1] ~= '') and output[1] or ''
            if vim.g.git_branch ~= branch then
                vim.g.git_branch = branch
                vim.schedule(function() vim.cmd.redrawstatus() end)
            end
        end,
    })
end

update_git_branch()

vim.api.nvim_create_autocmd({ 'DirChanged', 'FocusGained' }, {
    group = vim.api.nvim_create_augroup('GitBranchTrack', { clear = true }),
    callback = update_git_branch,
})

require('blame').setup()

vim.keymap.set('n', '<leader>gb', vim.cmd.BlameToggle, { desc = 'Blame', silent = true })

local function lazygit()
    if vim.fn.executable('lazygit') ~= 1 then
        vim.notify('lazygit not found in PATH', vim.log.levels.ERROR)
        return
    end

    -- new tab with a fresh [No Name] buffer that we'll turn into the terminal
    vim.cmd.tabnew()
    local buf = vim.api.nvim_get_current_buf()

    vim.fn.jobstart({ 'lazygit' }, {
        term = true,
        on_exit = function()
            -- reload any buffers lazygit changed on disk (checkout, stash, etc.)
            vim.cmd('silent! checktime')
            -- closing the terminal buffer closes its tab and returns you to the previous tab automatically
            if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
        end,
    })

    vim.api.nvim_buf_set_name(buf, 'gitu')
    vim.cmd.startinsert()
end
vim.api.nvim_create_user_command('LazyGit', lazygit, {})
vim.keymap.set('n', '<leader>gg', vim.cmd.LazyGit, { desc = 'Git' })

function EditLineFromLazygit(file_path, line)
    local path = vim.fn.expand('%:p')
    if path == file_path then
        vim.cmd(tostring(line))
    else
        vim.cmd('e ' .. file_path)
        vim.cmd(tostring(line))
    end
end

function EditFromLazygit(file_path)
    local path = vim.fn.expand('%:p')
    if path == file_path then
        return
    else
        vim.cmd('e ' .. file_path)
    end
end
