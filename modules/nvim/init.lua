vim.g.mapleader = vim.keycode('<space>')
vim.g.maplocalleader = vim.keycode('<space>')
vim.loader.enable()
vim.o.exrc = true
vim.cmd.packadd('nvim.undotree')
_G.nixCats = require('nixCats')
