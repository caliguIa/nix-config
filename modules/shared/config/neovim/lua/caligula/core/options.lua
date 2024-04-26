local opt = vim.opt
local global = vim.g
local wo = vim.wo

global.mapleader = ' '
global.maplocalleader = ' '
global.loaded_netrw = 1
global.loaded_netrwPlugin = 1

opt.hlsearch = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
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
opt.completeopt = 'menuone,noselect'
opt.termguicolors = true
opt.swapfile = false
opt.wrap = false
opt.spell = false
opt.spelllang = { 'en_us' }

wo.signcolumn = 'yes'
wo.number = true
wo.relativenumber = true
vim.diagnostic.config { float = { border = 'rounded' } }
