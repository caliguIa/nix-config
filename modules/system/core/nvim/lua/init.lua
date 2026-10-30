vim.g.mapleader = vim.keycode('<space>')
vim.g.maplocalleader = vim.keycode('<space>')
vim.loader.enable()

-- diffs.nvim reads this at load time, so it must be set before vim.pack sources it
vim.g.diffs = {
    integrations = {
        neogit = true,
    },
}
