vim.g.mapleader = vim.keycode('<space>')
vim.g.maplocalleader = vim.keycode('<space>')
vim.loader.enable()
vim.o.exrc = true
vim.cmd.packadd('nvim.undotree')
vim.schedule(function()
    require('vim._extui').enable({
        enable = true,
        msg = {
            target = 'msg', -- for now I'm happy with 'cmd'; 'box' seems buggy
        },
    })
end)
_G.nixCats = require('nixCats')
