-- Restart - keeps session intact
local restart_session = '/tmp/nvim_restart_session.vim'
vim.api.nvim_create_user_command('Restart', function()
    vim.cmd.mksession({ args = { vim.fn.fnameescape(restart_session) }, bang = true })
    vim.cmd.restart()
end, { desc = 'Restart neovim but maintain session' })
if vim.fn.filereadable(restart_session) == 1 then
    vim.cmd.source(vim.fn.fnameescape(restart_session))
    vim.fn.delete(restart_session)
    vim.notify('Restarted nvim', vim.log.levels.INFO)
end

-- Set find func
function _G.FuzzyFindFunc(cmdarg) return vim.fn.systemlist("fd --hidden . | fzf --filter='" .. cmdarg .. "'") end
if vim.fn.executable('fd') == 1 and vim.fn.executable('fzf') == 1 then vim.o.findfunc = 'v:lua.FuzzyFindFunc' end

vim.api.nvim_create_user_command('Update', function()
    local inactive = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()
    vim.pack.del(inactive)
    vim.pack.update()
    vim.cmd.Restart()
end, { desc = 'Update plugins' })
vim.api.nvim_create_user_command('DeletePlugins', function() end, { desc = 'Update plugins' })
