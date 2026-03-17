require('codediff').setup()

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

vim.api.nvim_create_autocmd({ 'DirChanged', 'BufEnter', 'FocusGained' }, {
    group = vim.api.nvim_create_augroup('GitBranchTrack', { clear = true }),
    callback = update_git_branch,
})

vim.keymap.set('n', '<leader>gd', vim.cmd.CodeDiff, { desc = 'Status', silent = true })

vim.api.nvim_create_user_command(
    'History',
    function() vim.cmd.CodeDiff('history HEAD~20 %') end,
    { desc = 'History (current file)' }
)
vim.api.nvim_create_user_command('Diff', function() vim.cmd.CodeDiff('file HEAD~1') end, { desc = 'Diff current file' })

vim.keymap.set('n', '<leader>gg', function()
    local server = vim.v.servername
    local winnr = vim.api.nvim_get_current_win()

    local script_path = '/tmp/gitu_open.sh'
    local script = string.format(
        [[#!/bin/sh
FILE="${1%%:*}"
LINE="${1##*:}"
[ "$FILE" = "$LINE" ] && LINE=""

LUA="vim.api.nvim_set_current_win(%d); vim.cmd('edit ' .. vim.fn.fnameescape('$FILE'))"
if [ -n "$LINE" ]; then
  LUA="$LUA; vim.api.nvim_win_set_cursor(0, {$LINE, 0})"
fi
LUA="$LUA; vim.api.nvim_exec_autocmds('User', { pattern = 'GituOpenFile' })"

nvim --server %s --remote-send "<C-\><C-N>:lua $LUA<CR>"
]],
        winnr,
        server
    )

    local f = io.open(script_path, 'w')
    if f == nil then return end
    f:write(script)
    f:close()
    os.execute('chmod +x ' .. script_path)

    vim.cmd('tabnew')
    local term_bufnr = vim.api.nvim_get_current_buf()
    local term_winnr = vim.api.nvim_get_current_win()

    local function cleanup()
        vim.schedule(function()
            if vim.api.nvim_win_is_valid(term_winnr) then vim.api.nvim_win_close(term_winnr, true) end
            if vim.api.nvim_buf_is_valid(term_bufnr) then vim.api.nvim_buf_delete(term_bufnr, { force = true }) end
        end)
    end

    local autocmd_id = vim.api.nvim_create_autocmd('User', {
        pattern = 'GituOpenFile',
        once = true,
        callback = cleanup,
    })

    vim.fn.jobstart('gitu', {
        term = true,
        env = { VISUAL = script_path },
        on_exit = function()
            pcall(vim.api.nvim_del_autocmd, autocmd_id)
            cleanup()
        end,
    })

    vim.api.nvim_buf_set_name(term_bufnr, 'gitu')
    vim.cmd('startinsert')
end, { desc = 'Open gitu' })
