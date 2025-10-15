local PhpUnitTransform = function(cmd)
    local parts = vim.split(cmd, ' ')
    for i, part in ipairs(parts) do
        if part == '--colors' then parts[i] = '--colors=always' end
    end
    return table.concat(parts, ' ')
end

vim.g['test#custom_transformations'] = { phpunit = PhpUnitTransform }
vim.g['test#transformation'] = 'phpunit'
vim.g['test#php#phpunit#options'] = '--colors=always'
vim.g['test#javascript#jest#options'] = '--color'
vim.g['test#strategy'] = 'neovim'
vim.g['test#neovim#start_normal'] = 0
vim.g['test#basic#start_normal'] = 0
vim.g['test#neovim#term_position'] = 'vert'
vim.g['test#javascript#runner'] = 'vitest'

local function RunVimTest(cmd_name)
    local root = require('lspconfig').util.root_pattern('tsconfig.json', 'package.json', 'jsconfig.json', '.git')(
        vim.fn.expand('%:p')
    )
    if root then vim.g['test#project_root'] = root end
    vim.cmd[cmd_name]()
end

vim.keymap.set(
    'n',
    '<leader>tr',
    function() RunVimTest('TestNearest') end,
    { desc = 'Run nearest test', silent = true }
)

vim.keymap.set(
    'n',
    '<leader>tf',
    function() RunVimTest('TestFile') end,
    { desc = 'Run all tests in the current file', silent = true }
)

vim.keymap.set(
    'n',
    '<leader>ta',
    function() RunVimTest('TestLast') end,
    { desc = 'Run last test again', silent = true }
)
