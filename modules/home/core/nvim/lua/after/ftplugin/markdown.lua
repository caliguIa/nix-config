vim.cmd.packadd('render-markdown.nvim')
vim.schedule(function() require('render-markdown').toggle() end)

vim.keymap.set('n', '<Leader>mp', function()
    local file = vim.fn.expand('%:p')
    vim.system({ 'open', file })
end, { buffer = true, desc = 'Open markdown in default app' })
