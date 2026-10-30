-- diffs.nvim reads this at load time. The user's plugin/ dir is sourced before
-- start plugins' plugin/ dirs, and this file sorts first within it.
vim.g.diffs = {
    integrations = {
        neogit = true,
    },
}
