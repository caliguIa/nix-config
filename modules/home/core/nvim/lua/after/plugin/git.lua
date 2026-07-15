local function ous_branch_prefix()
    local cwd = vim.fn.getcwd()
    if cwd:match('/ous/') then return 'OUS-' end
    return ''
end

require('neogit').setup({
    treesitter_diff_highlight = true,
    initial_branch_name = ous_branch_prefix(),
})

vim.g.diffs = {
    integrations = {
        neogit = true,
    },
}

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

vim.keymap.set('n', '<leader>gg', vim.cmd.Neogit, { desc = 'Git' })
