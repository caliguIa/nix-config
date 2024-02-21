-- harpoon keymaps
vim.keymap.set("n", "<leader>h", "<CMD>lua require('harpoon.ui').toggle_quick_menu()<CR>", {
  silent = true,
  desc = "[H]arpoon menu",
})
vim.keymap.set("n", "ma", "<CMD>lua require('harpoon.mark').add_file()<CR>", {
  silent = true,
  desc = "[M]ark [A]dd file",
})
vim.keymap.set("n", "mj", "<CMD>lua require('harpoon.ui').nav_file(1)<CR>", {
  silent = true,
  desc = "Harpoon jump to [M]ark [J] (1)",
})
vim.keymap.set("n", "mk", "<CMD>lua require('harpoon.ui').nav_file(2)<CR>", {
  silent = true,
  desc = "Harpoon jump to [M]ark [K] (2)",
})
vim.keymap.set("n", "ml", "<CMD>lua require('harpoon.ui').nav_file(3)<CR>", {
  silent = true,
  desc = "Harpoon jump to [M]ark [L] (3)",
})
vim.keymap.set("n", "m;", "<CMD>lua require('harpoon.ui').nav_file(4)<CR>", {
  silent = true,
  desc = "Harpoon jump to [M]ark [;] (4)",
})
