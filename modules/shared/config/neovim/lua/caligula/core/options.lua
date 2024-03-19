local opt = vim.opt
local global = vim.g

global.mapleader = " "
global.maplocalleader = " "
global.loaded_netrw = 1
global.loaded_netrwPlugin = 1
opt.hlsearch = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.autoread = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 10
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 300
opt.completeopt = "menuone,noselect"
opt.termguicolors = true
opt.swapfile = false
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.wo.signcolumn = "yes"
vim.wo.number = true
vim.diagnostic.config({ float = { border = "rounded" } })
