vim.g.mapleader = vim.keycode('<space>')
vim.g.maplocalleader = vim.keycode('<space>')
vim.loader.enable()
vim.cmd.packadd('nvim.undotree')
vim.schedule(
    function()
        require('vim._core.ui2').enable({
            enable = true,
            msg = {
                target = 'msg',
            },
        })
    end
)
